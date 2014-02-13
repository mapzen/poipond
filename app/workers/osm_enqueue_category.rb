class OsmEnqueueCategory

  include Sidekiq::Worker

  def perform(category_id)
    category = Category.find(category_id)
    %w(point line polygon).each do |shape|
      open_cursor(category, shape)
      osm_type = shape=='point' ? 'node' : 'way'
      begin
        results = Osm.connection.execute("FETCH 1000 FROM #{cursor_name(category, shape)}")
        results.each do |osm_poi|
          OsmBuildPoi.perform_async(osm_type, osm_poi, category.id)
        end
      end while results.count > 0
      close_cursor(category, shape)
    end
  end

  private

  def open_cursor(category, shape)
    Osm.connection.execute("BEGIN")
    Osm.connection.execute("
      DECLARE #{cursor_name(category, shape)} CURSOR FOR
      SELECT
        osm_id,
        \"addr:housenumber\",
        \"addr:street\",
        \"addr:postcode\",
        \"addr:city\",
        ST_AsGeoJSON(ST_Transform(ST_Centroid(way),4326),6),
        name,
        phone,
        website
      FROM planet_osm_#{shape}
      WHERE #{category.sql_where}
    ")
  end

  def close_cursor(category, shape)
    Osm.connection.execute("CLOSE #{cursor_name(category, shape)}")
    Osm.connection.execute("COMMIT")
  end

  def cursor_name(category, shape)
    "category_#{category.id}_#{shape}_cursor"
  end

end
