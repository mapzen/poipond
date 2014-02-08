class OsmUpload

  include Sidekiq::Worker

  def perform(user_id, poi_id)
    user = User.find(user_id)
    poi = Poi.find(poi_id)
    if poi.osm_id.nil?
      poi.create_osm_poi(user)
    else
      poi.update_osm_poi(user)
    end
  end

end
