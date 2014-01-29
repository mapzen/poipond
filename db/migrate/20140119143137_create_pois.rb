class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :osm_type
      t.string :osm_id
      t.string :name
      t.string :addr_housenumber
      t.string :addr_street
      t.string :addr_city
      t.string :addr_postcode
      t.string :phone
      t.string :website
      t.string :version
      t.text :tags
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :lon, precision: 15, scale: 10
      t.timestamps
    end
    add_index :pois, [:osm_type, :osm_id], :unique=>true
    add_index :pois, [:lat, :lon]
  end
end
