require 'xmlsimple'

class Poi

  attr_accessor :user
  attr_accessor :osm_type
  attr_accessor :osm_id
  attr_accessor :lat
  attr_accessor :lon
  attr_accessor :version
  attr_accessor :name
  attr_accessor :addr_housenumber
  attr_accessor :addr_street
  attr_accessor :addr_city
  attr_accessor :addr_postcode
  attr_accessor :phone
  attr_accessor :website
  attr_accessor :amenity
  attr_accessor :cuisine
  attr_accessor :tags
  attr_accessor :changeset

  def initialize(params={})
    self.user = params[:user]
    raise 'Missing user' if user.nil?
    self.osm_type = get_type(params[:osm_type])
    raise 'Missing type' if osm_type.nil?
    self.osm_id = params[:osm_id]
    self.tags = params[:tags] || {}
    self.update_attributes(params)
  end

  def update_attributes(params={})
    self.lat ||= params[:lat]
    self.lon ||= params[:lon]
    self.name ||= params[:name]
    self.addr_housenumber ||= params[:addr_housenumber]
    self.addr_street ||= params[:addr_street]
    self.addr_city ||= params[:addr_city]
    self.addr_postcode ||= params[:addr_postcode]
    self.phone ||= params[:phone]
    self.website ||= params[:website]
    self.amenity ||= params[:amenity]
    self.cuisine ||= params[:cuisine]
  end

  def save
    self.changeset = Changeset.new(:user=>user)
    changeset.create
    if osm_id.nil? && version.nil?
      # create new
      url = "#{OSM_API_BASE}/#{osm_type}/create"
    else
      # edit existing
      url = "#{OSM_API_BASE}/#{osm_type}/#{osm_id}"
    end
    response = user.osm_access_token.put(url, poi_xml, {'Content-Type'=>'application/xml'})
    changeset.close
    raise response.class.name unless response.code=='200'
  end

  def load_remote_data
    raise 'Missing osm_id and/or osm_type' if osm_type.nil? || osm_id.nil?
    response = user.osm_access_token.get("#{OSM_API_BASE}/#{osm_type}/#{osm_id}")
    hash = XmlSimple.xml_in(response.body)[osm_type].first
    self.lat = hash['lat']
    self.lon = hash['lon']
    self.version = hash['version']
    self.tags = build_tags(hash['tag'])
    self.name = tags[:name]
    self.addr_housenumber = tags[:addr_housenumber]
    self.addr_street = tags[:addr_street]
    self.addr_city = tags[:addr_city]
    self.addr_postcode = tags[:addr_postcode]
    self.phone = tags[:phone]
    self.website = tags[:website]
    self.amenity = tags[:amenity]
    self.cuisine = tags[:cuisine]
    true
  end

  def build_tags(tags)
    hash = {}
    tags.each do |tag|
      key = tag['k'].gsub(':', '_')
      hash[key] = tag['v']
    end
    hash.symbolize_keys
  end

  def xml_tags
    self.tags[:name] = name unless name.nil?
    self.tags[:addr_housenumber] = addr_housenumber unless addr_housenumber.nil?
    self.tags[:addr_street] = addr_street unless addr_street.nil?
    self.tags[:addr_city] = addr_city unless addr_city.nil?
    self.tags[:addr_postcode] = addr_postcode unless addr_postcode.nil?
    self.tags[:phone] = phone unless phone.nil?
    self.tags[:website] = website unless website.nil?
    self.tags[:amenity] = amenity unless amenity.nil?
    self.tags[:cuisine] = cuisine unless cuisine.nil?
    self.tags = self.tags.delete_if { |k,v| v.blank? }
    xml = ''
    self.tags.each do |k,v|
      key = k.to_s.gsub('_', ':')
      xml << "<tag k=\"#{key}\" v=\"#{v}\"/>"
    end
    xml
  end

  def poi_xml
    xml = "<osm>"
    xml << "<#{osm_type} visible=\"true\" "
    xml << "id=\"#{osm_id}\" " unless osm_id.nil?
    xml << "version=\"#{version}\" " unless version.nil?
    xml << "changeset=\"#{changeset.id}\" timestamp=\"#{Time.now.utc}\" "
    xml << "user=\"#{user.display_name}\" uid=\"#{user.uid}\" "
    xml << "lat=\"#{lat}\" lon=\"#{lon}\">"
    xml << xml_tags
    xml << "</#{osm_type}>"
    xml << "</osm>"
    xml
  end

  def get_type(type)
    return 'node' if type=='point'
    return 'way' if type=='line' || type=='polygon'
    type
  end

end
