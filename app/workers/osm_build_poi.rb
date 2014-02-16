class OsmBuildPoi

  include Sidekiq::Worker

  def perform(osm_type, osm_poi, category_id)
    category = Category.find(category_id)
    latlon = JSON.parse(osm_poi['st_asgeojson'])
    poi = Poi.where(osm_id: osm_poi['osm_id'], osm_type: osm_type).first
    poi = Poi.new(osm_id: osm_poi['osm_id'], osm_type: osm_type) if poi.nil?
    name = osm_poi['name']
    name = category.name if name.blank?
    poi.update_attributes!(
      :name => name,
      :addr_housenumber => osm_poi['addr:housenumber'],
      :addr_street => osm_poi['addr:street'],
      :addr_city => osm_poi['addr:city'],
      :addr_postcode => osm_poi['addr:postcode'],
      :phone => osm_poi['phone'],
      :website => osm_poi['website'],
      :lat => latlon['coordinates'][1],
      :lon => latlon['coordinates'][0]
    )
    poi.categories << category unless poi.categories.include? category
  end

end
