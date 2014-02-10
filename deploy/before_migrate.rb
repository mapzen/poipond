Chef::Log.info("Running deploy/before_migrate.rb...")

node[:mapzen_poipond][:custom_cfgs].each do |cfg|
  template "#{shared_path}/config" do
    source "#{cfg}.erb"
    mode 0644
  end

  link "#{release_path}/config/#{cfg}" do
    to "#{shared_path}/config/#{cfg}"
  end
end

