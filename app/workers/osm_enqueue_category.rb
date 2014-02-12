class OsmEnqueueCategory

  include Sidekiq::Worker

  def perform(category_id)
    category = Category.find(category_id)
    %w(point line polygon).each do |shape|
      osm_type = shape=='point' ? 'node' : 'way'
      offset = 0
      limit = 1000
      begin
        results = Osm.connection.select_all("
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
          LIMIT #{limit} OFFSET #{offset}
        ")
        offset += limit
        results.each do |osm_poi|
          OsmBuildPoi.perform_async(osm_type, osm_poi, category.id)
        end
      end while results.count > 0
    end
  end

end
