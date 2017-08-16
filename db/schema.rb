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

ActiveRecord::Schema.define(version: 20170816202633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.string "imei", limit: 16
    t.string "os"
    t.string "phone", limit: 20
    t.string "owner", limit: 120
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "terminal_id"
    t.boolean "current", default: true
    t.index ["imei"], name: "index_devices_on_imei"
    t.index ["terminal_id"], name: "index_devices_on_terminal_id"
  end

  create_table "terminals", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pairing_token"
    t.boolean "paired", default: false
    t.index ["name"], name: "index_terminals_on_name"
    t.index ["pairing_token"], name: "index_terminals_on_pairing_token"
    t.index ["status"], name: "index_terminals_on_status"
  end

  add_foreign_key "devices", "terminals"
end
