Chef::Log.info("Running deploy/before_migrate.rb...")

 node[:mapzen_poipond][:custom_cfgs].each do |cfg|
  Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to #{node[:mapzen_poipond][:cfg_dir]}/#{cfg}")

   link "#{release_path}/config/#{cfg}" do
     to "#{node[:mapzen_poipond][:cfg_dir]}/#{cfg}"
     to "#{shared_path}/config/#{cfg}"
   end
 end

