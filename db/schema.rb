# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_04_07_151049) do
  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.datetime "date_uploads"
    t.string "cover"
    t.boolean "download_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id"
    t.string "artist_name"
  end

# Could not dump table "artists" because of following StandardError
#   Unknown type 'category' for column 'string'


  create_table "dowload_logs", force: :cascade do |t|
    t.integer "download_id"
    t.datetime "download_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.text "subject"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
    t.date "date"
    t.string "start_time"
    t.string "venue"
    t.string "image"
    t.text "summary"
    t.text "image_data"
    t.boolean "featured"
    t.decimal "standard_ticket_price", precision: 10, scale: 2
    t.decimal "vip_ticket_price", precision: 10, scale: 2
    t.string "currency", default: "USD", null: false
  end

  create_table "feature_banners", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", force: :cascade do |t|
    t.text "link"
    t.text "image"
    t.text "intro"
    t.text "thumb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "heading"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "image"
    t.text "image_data"
  end

  create_table "gallery_banners", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer "gallery_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.text "file_data"
    t.text "image_data"
  end

  create_table "lifestyle_banners", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lifestyles", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.string "link"
    t.string "intro"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "main_banners", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "title"
    t.string "page"
    t.text "image_data"
    t.boolean "ticket_promo"
  end

  create_table "music_banners", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standard_tickets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_standard_tickets_on_event_id"
    t.index ["user_id"], name: "index_standard_tickets_on_user_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "cover"
    t.string "email"
    t.string "contact_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.integer "artist_id"
    t.string "cover"
    t.string "intro"
    t.string "thumb"
    t.string "track"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "category"
    t.integer "album_id"
    t.string "artist_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "link"
    t.string "title"
    t.datetime "published_at"
    t.integer "likes"
    t.integer "dislikes"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.index ["uid"], name: "index_videos_on_uid"
  end

  create_table "vip_tickets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_vip_tickets_on_event_id"
    t.index ["user_id"], name: "index_vip_tickets_on_user_id"
  end

  add_foreign_key "standard_tickets", "events"
  add_foreign_key "standard_tickets", "users"
  add_foreign_key "vip_tickets", "events"
  add_foreign_key "vip_tickets", "users"
end
