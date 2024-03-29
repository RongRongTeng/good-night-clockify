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

ActiveRecord::Schema[7.0].define(version: 2023_06_26_092109) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gist"
  enable_extension "plpgsql"

  create_table "sleep_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "clocked_in", precision: nil, null: false
    t.datetime "clocked_out", precision: nil
    t.integer "duration_in_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "user_id, tsrange(clocked_in, COALESCE(clocked_out, clocked_in), '[]'::text)", name: "sleep_records_clocked_duration_no_overlap_within_user", using: :gist
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
    t.check_constraint "clocked_in < clocked_out", name: "sleep_records_clocked_in_and_clocked_out_sequence"
  end

  create_table "user_relationships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_user_relationships_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_user_relationships_on_follower_id"
    t.index ["following_id"], name: "index_user_relationships_on_following_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
  end

  add_foreign_key "sleep_records", "users"
  add_foreign_key "user_relationships", "users", column: "follower_id"
  add_foreign_key "user_relationships", "users", column: "following_id"
end
