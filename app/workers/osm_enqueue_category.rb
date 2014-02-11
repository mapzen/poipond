class OsmEnqueueCategory

  include Sidekiq::Worker

  def perform(category_id, where)
    %w(point line polygon).each do |shape|
      osm_type = shape=='point' ? 'node' : 'way'
      Osm.pois(shape, where).each do |osm_poi|
        OsmBuildPoi.perform_async(osm_type, osm_poi, category_id)
      end
    end
  end

end
