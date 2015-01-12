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

ActiveRecord::Schema.define(version: 20150112182602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_facebook_applications", force: true do |t|
    t.string   "app_id"
    t.string   "app_secret"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fb_api_tokens", force: true do |t|
    t.text     "token"
    t.datetime "expires"
    t.integer  "application_id",          limit: 8
    t.text     "application_name"
    t.integer  "user_id",                 limit: 8
    t.text     "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "facebook_application_id"
    t.string   "purpose"
  end

  add_index "fb_api_tokens", ["expires"], name: "index_fb_api_tokens_on_expires", using: :btree
  add_index "fb_api_tokens", ["purpose"], name: "index_fb_api_tokens_on_purpose", using: :btree

  create_table "posts", force: true do |t|
    t.string   "status"
    t.string   "duration"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "timestamp"
    t.integer  "social_media_account_id"
    t.integer  "raw_post_id"
  end

  add_index "posts", ["raw_post_id"], name: "index_posts_on_raw_post_id", using: :btree
  add_index "posts", ["social_media_account_id"], name: "index_posts_on_social_media_account_id", using: :btree

  create_table "raw_posts", force: true do |t|
    t.json     "post"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_in_site"
    t.integer  "social_media_account_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "raw_posts", ["id_in_site"], name: "index_raw_posts_on_id_in_site", using: :btree
  add_index "raw_posts", ["social_media_account_id"], name: "index_raw_posts_on_social_media_account_id", using: :btree
  add_index "raw_posts", ["timestamp"], name: "index_raw_posts_on_timestamp", using: :btree

  create_table "social_media_accounts", force: true do |t|
    t.integer  "yair_id"
    t.string   "site"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "name"
    t.text     "about"
  end

  add_index "social_media_accounts", ["yair_id"], name: "index_social_media_accounts_on_yair_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "yairs", force: true do |t|
    t.string   "party"
    t.string   "field"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

end
