require 'xmlsimple'

class OsmDownload

  include Sidekiq::Worker

  def perform(user_id, poi_id)
    user = User.find(user_id)
    poi = Poi.find(poi_id)
    return if poi.osm_id.to_i < 0
    url = "#{OSM_API_BASE}/#{poi.osm_type}/#{poi.osm_id}"
    response = user.osm_access_token.get(url)
    hash = XmlSimple.xml_in(response.body)[poi.osm_type].first.symbolize_keys
    tags = Poi.decode_tags(hash[:tag])
    poi.update_attributes(
      :lat => (hash[:lat] || poi.lat),
      :lon => (hash[:lon] || poi.lon),
      :version => hash[:version],
      :tags => tags,
      :name => tags[:name],
      :addr_housenumber => tags[:addr_housenumber],
      :addr_street => tags[:addr_street],
      :addr_city => tags[:addr_city],
      :addr_postcode => tags[:addr_postcode],
      :phone => tags[:phone],
      :website => tags[:website]
    )
  end

end
