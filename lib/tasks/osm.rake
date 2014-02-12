namespace :osm do

  task :get => :environment do
    Category.all.each do |category|
      next unless where = category.sql_where
      OsmEnqueueCategory.perform_async(category.id)
      sleep 10
    end    
  end

end
