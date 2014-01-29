class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :icon
      t.integer :parent_id
      t.text :tags
      t.timestamps
    end
  end
end
