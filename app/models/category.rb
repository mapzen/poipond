class Category < ActiveRecord::Base

  serialize :tags, Hash
  validates :name, presence: true
  belongs_to :parent, :class_name => 'Category', :foreign_key => :parent_id
  has_many :children, :class_name => 'Category', :foreign_key => :parent_id
  has_many :poi_categories
  has_many :pois, through: :poi_categories
  scope :top, -> { where('parent_id IS NULL') }
  default_scope { order(:name) }

  def sql_where
    return if tags.empty?
    sql = tags.map do |tag|
      key = "\"#{tag.first}\""
      val = tag[1].gsub("'", "\'")
      "#{key}='#{val}'"
    end
    sql.uniq * ' AND '
  end

end
