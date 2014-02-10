Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_poipond][:custom_cfgs].each do |cfg|
  template "/srv/www/poipond/shared/config" do
    source "#{cfg}.erb"
    mode 0644
  end

  link "#{release_path}/config/#{cfg}" do
    to "/srv/www/poipond/shared/config/#{cfg}"
  end
end

