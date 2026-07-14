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

ActiveRecord::Schema[7.2].define(version: 2025_11_03_000002) do
  create_table "ad_spots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "page", null: false
    t.string "position", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.string "currency", default: "USD", null: false
    t.boolean "active", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_ad_spots_on_active"
    t.index ["page", "position"], name: "index_ad_spots_on_page_and_position", unique: true
    t.index ["page"], name: "index_ad_spots_on_page"
    t.index ["position"], name: "index_ad_spots_on_position"
  end

  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "ads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.text "image"
    t.text "image_data"
    t.string "url"
    t.bigint "ad_spot_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "active", default: true, null: false
    t.integer "impressions", default: 0, null: false
    t.integer "clicks", default: 0, null: false
    t.string "advertiser_name"
    t.string "advertiser_email"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_ads_on_active"
    t.index ["ad_spot_id", "active"], name: "index_ads_on_ad_spot_id_and_active"
    t.index ["ad_spot_id"], name: "index_ads_on_ad_spot_id"
    t.index ["start_date", "end_date"], name: "index_ads_on_start_date_and_end_date"
  end

  create_table "albums", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "date_uploads"
    t.string "cover"
    t.boolean "download_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "artist_id"
    t.string "artist_name"
  end

  create_table "artists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "cell_number"
    t.text "bio"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cover"
    t.string "profile_picture"
  end

  create_table "cart_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "store_id", null: false
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_carts_on_session_id"
    t.index ["store_id"], name: "index_carts_on_store_id"
    t.index ["user_id", "store_id"], name: "index_carts_on_user_id_and_store_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "dowload_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "download_id"
    t.datetime "download_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.text "subject"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "feature_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "link"
    t.text "image"
    t.text "intro"
    t.text "thumb"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "heading"
  end

  create_table "friendly_id_slugs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "galleries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "image"
    t.text "image_data"
  end

  create_table "gallery_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "gallery_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.text "file_data"
    t.text "image_data"
  end

  create_table "lifestyle_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lifestyles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.string "link"
    t.string "intro"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "main_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "title"
    t.string "page"
    t.text "image_data"
    t.boolean "ticket_promo"
  end

  create_table "malls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.string "contact_email"
    t.string "contact_phone"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_malls_on_slug", unique: true
  end

  create_table "music_banners", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.string "image"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "pending", null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "currency", default: "USD", null: false
    t.text "shipping_address"
    t.text "billing_address"
    t.string "shipping_name"
    t.string "shipping_phone"
    t.string "stripe_payment_intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_orders_on_status"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["stripe_payment_intent_id"], name: "index_orders_on_stripe_payment_intent_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "currency", default: "USD", null: false
    t.string "status", default: "pending", null: false
    t.string "stripe_charge_id"
    t.string "stripe_payment_intent_id"
    t.string "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id"
  end

  create_table "product_images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "image"
    t.string "alt_text"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_product_images_on_position"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "sku"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "compare_at_price", precision: 10, scale: 2
    t.integer "inventory_quantity", default: 0, null: false
    t.decimal "weight", precision: 8, scale: 2
    t.string "status", default: "active", null: false
    t.boolean "featured", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["status"], name: "index_products_on_status"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio"
    t.string "phone"
    t.string "website"
    t.string "profile_picture"
    t.string "cover_image"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "instagram_url"
    t.string "linkedin_url"
    t.string "youtube_url"
    t.string "spotify_url"
    t.string "soundcloud_url"
    t.string "pinterest_url"
    t.string "tiktok_url"
    t.text "specialization"
    t.text "experience"
    t.string "location"
    t.boolean "public_profile", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "profile_picture_data"
    t.text "cover_image_data"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "standard_tickets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_standard_tickets_on_event_id"
    t.index ["user_id"], name: "index_standard_tickets_on_user_id"
  end

  create_table "storefront_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "primary_color", default: "#007bff"
    t.string "secondary_color", default: "#6c757d"
    t.string "accent_color", default: "#28a745"
    t.string "logo"
    t.string "banner_image"
    t.text "custom_css"
    t.string "font_family", default: "Arial, sans-serif"
    t.string "theme", default: "default", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_storefront_settings_on_store_id", unique: true
  end

  create_table "stores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "cover"
    t.string "email"
    t.string "contact_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "mall_id"
    t.boolean "active", default: true, null: false
    t.string "currency", default: "USD", null: false
    t.string "slug"
    t.index ["mall_id"], name: "index_stores_on_mall_id"
    t.index ["slug"], name: "index_stores_on_slug", unique: true
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "ticket_listings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.string "ticket_type", default: "standard", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "sold_quantity", default: 0, null: false
    t.text "description"
    t.string "status", default: "available", null: false
    t.decimal "original_price", precision: 10, scale: 2
    t.string "currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "status"], name: "index_ticket_listings_on_event_id_and_status"
    t.index ["event_id"], name: "index_ticket_listings_on_event_id"
    t.index ["ticket_type"], name: "index_ticket_listings_on_ticket_type"
    t.index ["user_id", "status"], name: "index_ticket_listings_on_user_id_and_status"
    t.index ["user_id"], name: "index_ticket_listings_on_user_id"
  end

  create_table "tracks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.string "name", default: "", null: false
    t.integer "role", default: 0, null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "vip_tickets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_vip_tickets_on_event_id"
    t.index ["user_id"], name: "index_vip_tickets_on_user_id"
  end

  add_foreign_key "ads", "ad_spots"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "stores"
  add_foreign_key "carts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_images", "products"
  add_foreign_key "products", "stores"
  add_foreign_key "profiles", "users"
  add_foreign_key "standard_tickets", "events"
  add_foreign_key "storefront_settings", "stores"
  add_foreign_key "stores", "malls"
  add_foreign_key "stores", "users"
  add_foreign_key "ticket_listings", "events"
  add_foreign_key "ticket_listings", "users"
  add_foreign_key "vip_tickets", "events"
end
