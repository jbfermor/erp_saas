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

ActiveRecord::Schema[8.0].define(version: 2025_10_31_142705) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "saas_accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "subdomain", null: false
    t.string "database_name", null: false
    t.string "status", default: "active", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_saas_accounts_on_plan_id"
    t.index ["slug"], name: "index_saas_accounts_on_slug", unique: true
    t.index ["subdomain"], name: "index_saas_accounts_on_subdomain", unique: true
  end

  create_table "saas_modules", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_saas_modules_on_key", unique: true
  end

  create_table "saas_plan_modules", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "module_id", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["module_id"], name: "index_saas_plan_modules_on_module_id"
    t.index ["plan_id", "module_id"], name: "index_saas_plan_modules_on_plan_id_and_module_id", unique: true
    t.index ["plan_id"], name: "index_saas_plan_modules_on_plan_id"
  end

  create_table "saas_plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_saas_plans_on_key", unique: true
  end

  create_table "saas_subscriptions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "module_id", null: false
    t.datetime "started_at", null: false
    t.datetime "expires_at"
    t.string "status", default: "active", null: false
    t.boolean "auto_renew", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "module_id"], name: "index_saas_subscriptions_on_account_id_and_module_id", unique: true
    t.index ["account_id"], name: "index_saas_subscriptions_on_account_id"
    t.index ["module_id"], name: "index_saas_subscriptions_on_module_id"
  end

  add_foreign_key "saas_accounts", "saas_plans", column: "plan_id"
  add_foreign_key "saas_plan_modules", "saas_modules", column: "module_id"
  add_foreign_key "saas_plan_modules", "saas_plans", column: "plan_id"
  add_foreign_key "saas_subscriptions", "saas_accounts", column: "account_id"
  add_foreign_key "saas_subscriptions", "saas_modules", column: "module_id"
end
