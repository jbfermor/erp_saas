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

ActiveRecord::Schema[8.0].define(version: 2025_11_01_140026) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "core_addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.uuid "address_type_id", null: false
    t.uuid "country_id", null: false
    t.string "street"
    t.string "city"
    t.string "postal_code"
    t.string "province"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_type_id"], name: "index_core_addresses_on_address_type_id"
    t.index ["addressable_type", "addressable_id"], name: "index_core_addresses_on_addressable"
    t.index ["country_id"], name: "index_core_addresses_on_country_id"
    t.index ["slug"], name: "index_core_addresses_on_slug", unique: true
  end

  create_table "core_bank_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entity_id", null: false
    t.string "bank_name"
    t.string "iban"
    t.string "swift"
    t.boolean "is_default"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_core_bank_infos_on_entity_id"
    t.index ["slug"], name: "index_core_bank_infos_on_slug", unique: true
  end

  create_table "core_business_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entity_id", null: false
    t.uuid "tax_type_id", null: false
    t.string "slug", null: false
    t.string "business_name"
    t.string "trade_name"
    t.string "tax_id"
    t.string "registration_number"
    t.string "phone"
    t.string "email"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_core_business_infos_on_entity_id"
    t.index ["slug"], name: "index_core_business_infos_on_slug", unique: true
    t.index ["tax_type_id"], name: "index_core_business_infos_on_tax_type_id"
  end

  create_table "core_companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.bigint "saas_account_id", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["saas_account_id"], name: "index_core_companies_on_saas_account_id"
    t.index ["slug"], name: "index_core_companies_on_slug", unique: true
  end

  create_table "core_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.uuid "entity_type_id", null: false
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_entities_on_company_id"
    t.index ["entity_type_id"], name: "index_core_entities_on_entity_type_id"
    t.index ["slug"], name: "index_core_entities_on_slug", unique: true
  end

  create_table "core_personal_infos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entity_id", null: false
    t.uuid "document_type_id"
    t.string "first_name"
    t.string "last_name"
    t.string "document_number"
    t.date "birth_date"
    t.string "phone"
    t.string "personal_email"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type_id"], name: "index_core_personal_infos_on_document_type_id"
    t.index ["entity_id"], name: "index_core_personal_infos_on_entity_id"
    t.index ["slug"], name: "index_core_personal_infos_on_slug", unique: true
  end

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

  create_table "saas_address_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_saas_address_types_on_code", unique: true
    t.index ["slug"], name: "index_saas_address_types_on_slug", unique: true
  end

  create_table "saas_countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "iso_code", null: false
    t.string "phone_prefix", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_code"], name: "index_saas_countries_on_iso_code", unique: true
    t.index ["phone_prefix"], name: "index_saas_countries_on_phone_prefix", unique: true
    t.index ["slug"], name: "index_saas_countries_on_slug", unique: true
  end

  create_table "saas_document_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.boolean "system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_saas_document_types_on_code", unique: true
    t.index ["slug"], name: "index_saas_document_types_on_slug", unique: true
  end

  create_table "saas_entity_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_saas_entity_types_on_code", unique: true
    t.index ["slug"], name: "index_saas_entity_types_on_slug", unique: true
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

  create_table "saas_tax_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.boolean "system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_saas_tax_types_on_code", unique: true
    t.index ["slug"], name: "index_saas_tax_types_on_slug", unique: true
  end

  add_foreign_key "core_addresses", "saas_address_types", column: "address_type_id"
  add_foreign_key "core_addresses", "saas_countries", column: "country_id"
  add_foreign_key "core_bank_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_business_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_business_infos", "saas_tax_types", column: "tax_type_id"
  add_foreign_key "core_companies", "saas_accounts"
  add_foreign_key "core_entities", "core_companies", column: "company_id"
  add_foreign_key "core_entities", "saas_entity_types", column: "entity_type_id"
  add_foreign_key "core_personal_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_personal_infos", "saas_document_types", column: "document_type_id"
  add_foreign_key "saas_accounts", "saas_plans", column: "plan_id"
  add_foreign_key "saas_plan_modules", "saas_modules", column: "module_id"
  add_foreign_key "saas_plan_modules", "saas_plans", column: "plan_id"
  add_foreign_key "saas_subscriptions", "saas_accounts", column: "account_id"
  add_foreign_key "saas_subscriptions", "saas_modules", column: "module_id"
end
