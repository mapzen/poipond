class OsmUpload

  include Sidekiq::Worker

  def perform(user_id, poi_id, changes)
    user = User.find(user_id)
    poi = Poi.find(poi_id)
    if poi.osm_id.nil?
      # create a new record if no osm_id
      poi.create_osm_poi(user, changes)
    else
      # otherwise update the existing record
      updated_attributes = poi.attributes
      begin
        # try to update
        poi.update_osm_poi(user, changes)
      rescue
        # failed? download again from osm api, maybe a version conflict
        OsmDownload.new.perform(user.id, poi.id)
        # and update with the new changes
        poi.update_attributes(
          :name => updated_attributes['name'],
          :addr_housenumber => updated_attributes['addr_housenumber'],
          :addr_street => updated_attributes['addr_street'],
          :addr_city => updated_attributes['addr_city'],
          :addr_postcode => updated_attributes['addr_postcode'],
          :phone => updated_attributes['phone'],
          :website => updated_attributes['website']
        )
        poi.reload
        # and try again...
        poi.update_osm_poi(user, changes)
      end
    end
  end

end
