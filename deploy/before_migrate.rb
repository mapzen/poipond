Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_poipond][:custom_cfgs].each do |cfg|
  template "#{deploy_to}/shared/config" do
    source "#{cfg}.erb"
    mode 0644
  end

  link "#{release_path}/config/#{cfg}" do
    to "#{deploy_to}/shared/config/#{cfg}"
  end
end

