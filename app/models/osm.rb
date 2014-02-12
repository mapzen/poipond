class Osm < ActiveRecord::Base

  self.abstract_class = true
  octopus_establish_connection("#{Rails.env}_osm")

end
