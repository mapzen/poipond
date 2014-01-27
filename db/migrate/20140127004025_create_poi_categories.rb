class CreatePoiCategories < ActiveRecord::Migration
  def change
    create_table :poi_categories do |t|
      t.integer :poi_id
      t.integer :category_id
    end
    add_index :poi_categories, [:poi_id, :category_id], :unique=>true
  end
end
