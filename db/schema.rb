# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080610162722) do

  create_table "article_versions", :force => true do |t|
    t.integer  "article_id",     :limit => 11
    t.integer  "version",        :limit => 11
    t.integer  "section_id",     :limit => 11
    t.string   "name",           :limit => 128
    t.text     "description"
    t.text     "content"
    t.integer  "author_id",      :limit => 11
    t.integer  "comments_count", :limit => 11,  :default => 0
    t.string   "live_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
  end

  create_table "articles", :force => true do |t|
    t.integer  "section_id",     :limit => 11
    t.string   "name",           :limit => 128
    t.text     "description"
    t.text     "content"
    t.integer  "author_id",      :limit => 11
    t.integer  "comments_count", :limit => 11,  :default => 0
    t.string   "live_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",        :limit => 11
    t.datetime "published_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "article_id", :limit => 11
    t.integer  "user_id",    :limit => 11
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.text     "content"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "component_versions", :force => true do |t|
    t.integer  "component_id", :limit => 11
    t.integer  "version",      :limit => 11
    t.integer  "theme_id",     :limit => 11
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "components", :force => true do |t|
    t.integer  "theme_id",   :limit => 11
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",    :limit => 11
  end

  create_table "config", :force => true do |t|
    t.integer "associated_id",   :limit => 11
    t.string  "associated_type"
    t.string  "namespace"
    t.string  "key",             :limit => 40, :default => "", :null => false
    t.string  "value"
  end

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id",            :limit => 11
    t.integer  "version",            :limit => 11
    t.integer  "section_id",         :limit => 11
    t.integer  "component_id",       :limit => 11
    t.string   "name"
    t.text     "content"
    t.integer  "last_updated_by_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "section_id",         :limit => 11
    t.integer  "component_id",       :limit => 11
    t.string   "name"
    t.text     "content"
    t.integer  "last_updated_by_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version",            :limit => 11
  end

  create_table "routes", :force => true do |t|
    t.integer "parent_id",       :limit => 11
    t.integer "associated_id",   :limit => 11
    t.string  "associated_type"
    t.string  "slug"
    t.text    "permalink"
    t.text    "redirect_to"
    t.boolean "active",                        :default => true
    t.integer "level",           :limit => 11
  end

  create_table "sections", :force => true do |t|
    t.integer  "theme_id",   :limit => 11
    t.string   "name"
    t.boolean  "root",                     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "system_name"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
