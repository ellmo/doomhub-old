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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120806163930) do

  create_table "authors", :force => true do |t|
    t.integer  "authorable_id"
    t.string   "authorable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "default_lumpname"
  end

  create_table "item_accesses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_invites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "invitable_id"
    t.string   "invitable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_images", :force => true do |t|
    t.integer  "map_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "imagefile_file_name"
    t.string   "imagefile_content_type"
    t.integer  "imagefile_file_size"
    t.datetime "imagefile_updated_at"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "map_wadfiles", :force => true do |t|
    t.integer  "map_id"
    t.integer  "author_id"
    t.string   "author_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wadfile_file_name"
    t.string   "wadfile_content_type"
    t.integer  "wadfile_file_size"
    t.datetime "wadfile_updated_at"
  end

  create_table "maps", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.text     "desc"
    t.string   "lump"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "author_id"
    t.string   "author_type"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "url_name",                          :null => false
    t.string   "slug",                              :null => false
    t.text     "description"
    t.integer  "game_id",                           :null => false
    t.integer  "source_port_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "public_view",    :default => true,  :null => false
    t.boolean  "public_join",    :default => false, :null => false
  end

  add_index "projects", ["slug"], :name => "index_projects_on_slug", :unique => true

  create_table "source_ports", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.integer  "user_role_id",                          :default => 3
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
