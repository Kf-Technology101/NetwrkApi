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

ActiveRecord::Schema.define(version: 20170615102440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deleted_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "message_id"
  end

  create_table "legendary_likes", force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "text"
    t.integer  "user_id"
    t.decimal  "lng"
    t.decimal  "lat"
    t.boolean  "undercover"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "network_id"
    t.boolean  "legendary"
    t.integer  "likes_count",     default: 0
    t.boolean  "public",          default: true
    t.boolean  "locked",          default: false
    t.string   "password_hash"
    t.string   "hint"
    t.string   "password_salt"
    t.boolean  "is_emoji",        default: false
    t.integer  "legendary_count", default: 0
    t.string   "social"
    t.string   "url"
    t.string   "post_permalink"
  end

  create_table "networks", force: :cascade do |t|
    t.integer  "post_code"
    t.string   "name"
    t.integer  "users_count"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "networks_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "invitation_sent", default: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "message"
    t.integer  "network_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "provider_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "auth_token"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birthday"
    t.string   "provider_id"
    t.string   "provider_name"
    t.boolean  "invitation_sent",          default: false
    t.string   "role_name"
    t.string   "role_description"
    t.string   "role_image_url"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "name"
    t.string   "hero_avatar_file_name"
    t.string   "hero_avatar_content_type"
    t.integer  "hero_avatar_file_size"
    t.datetime "hero_avatar_updated_at"
    t.integer  "gender"
    t.datetime "legendary_at"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
