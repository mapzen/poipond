# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140127004025) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.integer  "parent_id"
    t.text     "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_categories", force: true do |t|
    t.integer "poi_id"
    t.integer "category_id"
  end

  add_index "poi_categories", ["poi_id", "category_id"], name: "index_poi_categories_on_poi_id_and_category_id", unique: true, using: :btree

  create_table "pois", force: true do |t|
    t.string   "osm_type"
    t.string   "osm_id"
    t.string   "name"
    t.string   "addr_housenumber"
    t.string   "addr_street"
    t.string   "addr_city"
    t.string   "addr_postcode"
    t.string   "phone"
    t.string   "website"
    t.string   "version"
    t.text     "tags"
    t.decimal  "lat",              precision: 15, scale: 10
    t.decimal  "lon",              precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pois", ["lat", "lon"], name: "index_pois_on_lat_and_lon", using: :btree
  add_index "pois", ["osm_type", "osm_id"], name: "index_pois_on_osm_type_and_osm_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "provider",                               null: false
    t.string   "uid",                                    null: false
    t.string   "token",                                  null: false
    t.string   "secret",                                 null: false
    t.string   "email",                                  null: false
    t.string   "display_name",                           null: false
    t.string   "image_url"
    t.decimal  "lat",          precision: 15, scale: 10
    t.decimal  "lon",          precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["display_name"], name: "index_users_on_display_name", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, using: :btree

end
