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

ActiveRecord::Schema.define(version: 20170824180300) do

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

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization"], name: "index_tenants_on_organization"
  end

  create_table "terminals", force: :cascade do |t|
    t.string "name"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pairing_token"
    t.boolean "paired", default: false
    t.string "access_token"
    t.bigint "tenant_id"
    t.index ["access_token"], name: "index_terminals_on_access_token", unique: true
    t.index ["name"], name: "index_terminals_on_name"
    t.index ["pairing_token"], name: "index_terminals_on_pairing_token", unique: true
    t.index ["status"], name: "index_terminals_on_status"
    t.index ["tenant_id"], name: "index_terminals_on_tenant_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tenant_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "devices", "terminals"
  add_foreign_key "terminals", "tenants"
  add_foreign_key "users", "tenants"
end
