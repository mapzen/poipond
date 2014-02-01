namespace :osm do

  task :get => :environment do
    Category.all.each do |category|
      next unless where=category.sql_where
      puts where
      %w(point line polygon).each do |shape|
        osm_type = shape=='point' ? 'node' : 'way'
        pois = Osm.pois(shape, where)
        puts pois.count
        pois.each do |osm_poi|
          latlon = JSON.parse(osm_poi['st_asgeojson'])
          poi = Poi.where(osm_id: osm_poi['osm_id'], osm_type: osm_type).first_or_create do |p|
            p.name = osm_poi['name']
            p.addr_housenumber = osm_poi['addr_housenumber']
            p.addr_street = osm_poi['addr_street']
            p.addr_city = osm_poi['addr_city']
            p.addr_postcode = osm_poi['addr_postcode']
            p.phone = osm_poi['phone']
            p.website = osm_poi['website']
            p.lat = latlon['coordinates'][1]
            p.lon = latlon['coordinates'][0]
          end
          next if poi.name.empty?
          poi.categories << category unless poi.categories.include? category
          poi.save if poi.changed?
        end
      end
    end    
  end

end
