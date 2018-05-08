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

ActiveRecord::Schema.define(version: 20180508010244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "position"
    t.bigint "stack_id"
    t.index ["stack_id"], name: "index_lessons_on_stack_id"
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_id", null: false
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "selections", force: :cascade do |t|
    t.bigint "stack_id"
    t.bigint "user_id"
    t.index ["stack_id"], name: "index_selections_on_stack_id"
    t.index ["user_id"], name: "index_selections_on_user_id"
  end

  create_table "stack_tracks", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "stack_id", null: false
    t.index ["stack_id"], name: "index_stack_tracks_on_stack_id"
    t.index ["track_id"], name: "index_stack_tracks_on_track_id"
  end

  create_table "stacks", force: :cascade do |t|
    t.string "title"
    t.bigint "category_id"
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
    t.string "summary"
    t.index ["category_id"], name: "index_stacks_on_category_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "current_period_end", null: false
    t.boolean "active", default: false, null: false
    t.string "status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", null: false
    t.string "icon_file_name"
    t.string "icon_content_type"
    t.integer "icon_file_size"
    t.datetime "icon_updated_at"
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
    t.string "name", null: false
    t.bigint "track_id"
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
  add_foreign_key "lessons", "stacks"
  add_foreign_key "plans", "users"
  add_foreign_key "selections", "stacks"
  add_foreign_key "selections", "users"
  add_foreign_key "stack_tracks", "stacks"
  add_foreign_key "stack_tracks", "tracks"
  add_foreign_key "stacks", "categories"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users", "tracks"
end
