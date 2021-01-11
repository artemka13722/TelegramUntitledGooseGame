# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_11_091036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", force: :cascade do |t|
    t.string "name_show"
    t.string "name_action"
    t.integer "fun"
    t.integer "mana"
    t.integer "health"
    t.integer "weariness"
    t.integer "money"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "actions_bonus", force: :cascade do |t|
    t.integer "fun"
    t.integer "mana"
    t.integer "health"
    t.integer "weariness"
    t.integer "money"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bonus_conditions", force: :cascade do |t|
    t.integer "fun"
    t.integer "mana"
    t.integer "health"
    t.integer "weariness"
    t.integer "money"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gooses", force: :cascade do |t|
    t.string "name"
    t.integer "fun"
    t.integer "mana"
    t.integer "health"
    t.integer "weariness"
    t.integer "money"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_gooses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "telegram_id"
    t.string "current_goose_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "gooses", "users"
end
