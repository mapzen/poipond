redis_config = YAML::load(File.open('config/redis.yml'))[Rails.env]
redis_url = "redis://#{redis_config['host']}:#{redis_config['port']}/12"
redis_namespace = redis_config['namespace']

Sidekiq.configure_server do |config|
  config.redis = { :url => redis_url, :namespace => redis_namespace }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => redis_url, :namespace => redis_namespace }
end
