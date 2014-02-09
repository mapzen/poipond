class CreateChangesets < ActiveRecord::Migration
  def change
    create_table :changesets do |t|
      t.integer :user_id
      t.integer :poi_id
      t.string :osm_id
      t.text :changes
      t.boolean :is_open
    end
    add_index :changesets, :user_id
    add_index :changesets, :poi_id
    add_index :changesets, :osm_id
  end
end
