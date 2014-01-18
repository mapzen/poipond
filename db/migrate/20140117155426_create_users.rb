class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :token, null: false
      t.string :secret, null: false
      t.string :email, null: false
      t.string :display_name, null: false
      t.string :image_url
      t.decimal :lat, precision: 15, scale: 10
      t.decimal :lon, precision: 15, scale: 10
      t.timestamps
    end
    add_index :users, [:provider, :uid], :unique=>true
    add_index :users, :display_name, :unique=>true
  end
end
