Rails.application.config.middleware.use OmniAuth::Builder do
  provider :osm, OSM_KEY, OSM_SECRET
end
