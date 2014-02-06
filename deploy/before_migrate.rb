Chef::Log.info("Running deploy/before_migrate.rb...")

cfgs = %w(shards.yml redis.yml).each do |cfg|
  Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to /etc/mapzen_poipond/#{cfg}")
  link "#{release_path}/config/#{cfg}" do
    to "/etc/mapzen_poipond/#{cfg}"
  end
end

