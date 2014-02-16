class OsmBuildPoi

  include Sidekiq::Worker

  def perform(osm_type, osm_poi, category_id)
    category = Category.find(category_id)
    latlon = JSON.parse(osm_poi['st_asgeojson'])
    poi = Poi.where(osm_id: osm_poi['osm_id'], osm_type: osm_type).first_or_create do |p|
      p.name = osm_poi['name']
      p.name = category.name if p.name.blank?
      p.addr_housenumber = osm_poi['addr:housenumber']
      p.addr_street = osm_poi['addr:street']
      p.addr_city = osm_poi['addr:city']
      p.addr_postcode = osm_poi['addr:postcode']
      p.phone = osm_poi['phone']
      p.website = osm_poi['website']
      p.lat = latlon['coordinates'][1]
      p.lon = latlon['coordinates'][0]
    end
    poi.categories << category unless poi.categories.include? category
    poi.save! if poi.changed?
  end

end
