Chef::Log.info("Running deploy/before_symlink.rb...")

rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")
execute "rake assets:precompile" do
  cwd release_path
  command "bundle exec rake assets:precompile"
  environment "RAILS_ENV" => rails_env
end

