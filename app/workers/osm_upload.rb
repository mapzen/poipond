class OsmUpload

  include Sidekiq::Worker

  def perform(user_id, poi_id)
    user = User.find(user_id)
    poi = Poi.find(poi_id)
    changeset = Changeset.new(:user=>user)
    changeset.create
    # edit existing if persisted, otherwise create new
    url = poi.osm_id.nil? ? "#{OSM_API_BASE}/#{poi.osm_type}/create" : "#{OSM_API_BASE}/#{poi.osm_type}/#{poi.osm_id}"
    xml = poi.to_xml(changeset, user)
    response = user.osm_access_token.put(url, xml, {'Content-Type'=>'application/xml'})
    changeset.close
    if response.code=='200'
      self.update_attributes(:osm_id=>response.body)
    else
      raise response.class.name
    end
  end

end
