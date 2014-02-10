namespace :osm do

  task :get => :environment do
    Category.all.each do |category|
      %w(point line polygon).each do |shape|
        OsmSync.perform_async(shape, category.id)
      end
    end    
  end
end
