Chef::Log.info("Running deploy/before_symlink.rb...")

rails_env = new_resource.environment["RAILS_ENV"]

node[:mapzen_poipond][:custom_cfgs].each do |cfg|
 Chef::Log.info("Symlinking #{release_path}/config/#{cfg} to #{node[:mapzen_poipond][:cfg_dir]}/#{cfg}")

  link "#{release_path}/config/#{cfg}" do
    to "#{node[:mapzen_poipond][:cfg_dir]}/#{cfg}"
  end
end

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end
