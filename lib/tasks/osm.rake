namespace :osm do

  task :get => :environment do
    Category.all.each do |category|
      next unless where=category.sql_where
      puts where
      %w(point line polygon).each do |shape|
        osm_type = shape=='point' ? 'node' : 'way'
        pois = Osm.pois(shape, where)
        puts "#{osm_type}: #{pois.count}"
        pois.each do |osm_poi|
          latlon = JSON.parse(osm_poi['st_asgeojson'])
          poi = Poi.where(osm_id: osm_poi['osm_id'], osm_type: osm_type).first_or_create do |p|
            p.name = utf8_enforce(osm_poi['name'])
            p.name = utf8_enforce(category.name) if p.name.blank?
            p.addr_housenumber = utf8_enforce(osm_poi['addr_housenumber'])
            p.addr_street = utf8_enforce(osm_poi['addr_street'])
            p.addr_city = utf8_enforce(osm_poi['addr_city'])
            p.addr_postcode = utf8_enforce(osm_poi['addr_postcode'])
            p.phone = utf8_enforce(osm_poi['phone'])
            p.website = utf8_enforce(osm_poi['website'])
            p.lat = latlon['coordinates'][1]
            p.lon = latlon['coordinates'][0]
          end
          poi.categories << category unless poi.categories.include? category
          poi.save if poi.changed?
        end
      end
    end    
  end

  def utf8_enforce(str)
    return if str.nil?
    str.encode('utf-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

end
