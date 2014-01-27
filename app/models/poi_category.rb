class PoiCategory < ActiveRecord::Base

  belongs_to :poi
  belongs_to :category

  validates :poi, uniqueness: { scope: :category }

end
