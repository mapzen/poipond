namespace :osm do

  task :get => :environment do
    Category.all.each do |category|
      next unless where = category.sql_where
      %w(point line polygon).each do |shape|
        puts "#{shape}: #{where}"
        osm_type = shape=='point' ? 'node' : 'way'
        Osm.pois(shape, where).each do |osm_poi|
          OsmSync.perform_async(osm_type, osm_poi, category.id)
        end
      end
    end    
  end
end
