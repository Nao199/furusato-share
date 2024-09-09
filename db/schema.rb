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

ActiveRecord::Schema[7.0].define(version: 2024_09_07_173827) do
  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "foods", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "quantity", null: false
    t.date "expiration_date", null: false
    t.text "allergen_info"
    t.integer "category_id", null: false
    t.integer "furusato_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "available_from", null: false
    t.datetime "available_until", null: false
    t.integer "pickup_location_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_foods_on_user_id"
  end

  create_table "points", charset: "utf8", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.integer "point_type", null: false
    t.bigint "user_id", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_points_on_transaction_id"
    t.index ["user_id"], name: "index_points_on_user_id"
  end

  create_table "transactions", charset: "utf8", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.bigint "receiver_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "completed_at"
    t.bigint "food_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_transactions_on_food_id"
    t.index ["provider_id"], name: "index_transactions_on_provider_id"
    t.index ["receiver_id"], name: "index_transactions_on_receiver_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "name_kana", null: false
    t.date "birth_date", null: false
    t.string "room_number", null: false
    t.text "allergies"
    t.text "preferences"
    t.integer "share_count", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "foods", "users"
  add_foreign_key "points", "transactions"
  add_foreign_key "points", "users"
  add_foreign_key "transactions", "foods"
  add_foreign_key "transactions", "users", column: "provider_id"
  add_foreign_key "transactions", "users", column: "receiver_id"
end
