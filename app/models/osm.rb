class Osm < ActiveRecord::Base

  self.abstract_class = true
  establish_connection("#{Rails.env}_osm")

  def self.poi_select_fields
    fields = %w(
      osm_id
      "addr:housenumber"
      "addr:street"
      "addr:postcode"
      "addr:city"
      ST_AsGeoJSON(ST_Transform(ST_Centroid(way),4326),6)
      name
      phone
      website
    )
    return "#{fields * ', '}"
  end

  def self.pois(shape, where)
    # point, line, polygon
    results = connection.select_all("
      SELECT #{self.poi_select_fields}
      FROM planet_osm_#{shape}
      WHERE #{where}
    ")
    pois = []
    results.rows.each do |row|
      poi = {}
      row.each_with_index do |val, idx|
        key = results.columns[idx].gsub(':', '_')
        poi[key] = val
      end
      pois << poi
    end
    pois
  end

end
