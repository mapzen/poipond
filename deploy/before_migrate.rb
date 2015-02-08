Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_poipond][:custom_cfgs].each do |cfg|
 Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to #{node[:mapzen_poipond][:cfg_dir]}/#{cfg}")

  link "#{release_path}/config/#{cfg}" do
    to "#{node[:mapzen_poipond][:cfg_dir]}/#{cfg}"
  end
end

template "#{node[:deploy][:poipond][:deploy_to]}/shared/config/database.yml" do
  cookbook  'mapzen_poipond'
  source    'database.yml.erb'
  owner     'www-data'
  mode      0644
  only_if { node[:hostname] =~ /^rails-app/ }
end
