json.array! @pois do |poi|
  json.id poi.id
  json.osm_type poi.osm_type
  json.osm_id poi.osm_id
  json.name poi.name
  json.addr_housenumber poi.addr_housenumber
  json.addr_street poi.addr_street
  full_addr = "#{poi.addr_housenumber} #{poi.addr_street}".strip
  json.full_addr (full_addr.blank? ? "No address" : full_addr)
  json.addr_city poi.addr_city
  json.addr_postcode poi.addr_postcode
  json.lat poi.lat.to_f.round(6)
  json.lon poi.lon.to_f.round(6)
  json.distance poi.distance.round(2)
  json.category_id poi.display_category.id
end
