OSM_API_BASE = '/api/0.6'
OSM_CLIENT = OAuth::Consumer.new(OSM_KEY, OSM_SECRET, :site=>'http://api.openstreetmap.org')
