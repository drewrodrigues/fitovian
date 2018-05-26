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

ActiveRecord::Schema.define(version: 2018_05_26_024622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last4", null: false
    t.boolean "default", default: false, null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "completions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "completable_id"
    t.string "completable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completable_type", "completable_id"], name: "index_completions_on_completable_type_and_completable_id"
    t.index ["user_id"], name: "index_completions_on_user_id"
  end

  create_table "course_tracks", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_course_tracks_on_course_id"
    t.index ["track_id"], name: "index_course_tracks_on_track_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.bigint "category_id"
    t.string "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_courses_on_category_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "email"
    t.string "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "position"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "selections", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "user_id"
    t.index ["course_id"], name: "index_selections_on_course_id"
    t.index ["user_id"], name: "index_selections_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", null: false
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "admin", default: false
    t.string "stripe_id"
    t.string "name"
    t.bigint "track_id"
    t.date "period_end", null: false
    t.string "plan", default: "starter", null: false
    t.boolean "active"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["track_id"], name: "index_users_on_track_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "cards", "users"
  add_foreign_key "course_tracks", "courses"
  add_foreign_key "course_tracks", "tracks"
  add_foreign_key "courses", "categories"
  add_foreign_key "lessons", "courses"
  add_foreign_key "selections", "courses"
  add_foreign_key "selections", "users"
  add_foreign_key "users", "tracks"
end
