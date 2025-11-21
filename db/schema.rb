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

ActiveRecord::Schema[8.0].define(version: 2025_11_20_171350) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.uuid "saas_account_id", null: false
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_core_companies_on_slug", unique: true
  end

  create_table "core_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entity_type_id", null: false
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_entities_on_company_id"
    t.index ["entity_type_id"], name: "index_core_entities_on_entity_type_id"
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

  create_table "core_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "module_id", null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_subscriptions_on_company_id"
    t.index ["module_id"], name: "index_core_subscriptions_on_module_id"
  end

  create_table "core_user_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "role_id", null: false
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_user_roles_on_company_id"
    t.index ["role_id"], name: "index_core_user_roles_on_role_id"
    t.index ["user_id", "role_id", "company_id"], name: "index_user_roles_unique", unique: true
    t.index ["user_id"], name: "index_core_user_roles_on_user_id"
  end

  create_table "core_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.uuid "company_id", null: false
    t.uuid "entity_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_core_users_on_company_id"
    t.index ["email"], name: "index_core_users_on_email", unique: true
    t.index ["entity_id"], name: "index_core_users_on_entity_id"
    t.index ["reset_password_token"], name: "index_core_users_on_reset_password_token", unique: true
  end

  create_table "master_data_address_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_master_data_address_types_on_code", unique: true
    t.index ["slug"], name: "index_master_data_address_types_on_slug", unique: true
  end

  create_table "master_data_countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "iso_code", null: false
    t.string "phone_prefix", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_code"], name: "index_master_data_countries_on_iso_code", unique: true
  end

  create_table "master_data_document_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.boolean "system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_master_data_document_types_on_code", unique: true
    t.index ["slug"], name: "index_master_data_document_types_on_slug", unique: true
  end

  create_table "master_data_entity_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_master_data_entity_types_on_code", unique: true
    t.index ["slug"], name: "index_master_data_entity_types_on_slug", unique: true
  end

  create_table "master_data_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "scope", null: false
    t.integer "position", default: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scope"], name: "index_master_data_roles_on_scope"
  end

  create_table "master_data_tax_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "slug", null: false
    t.boolean "system"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_master_data_tax_types_on_code", unique: true
    t.index ["slug"], name: "index_master_data_tax_types_on_slug", unique: true
  end

  create_table "saas_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "subdomain", null: false
    t.string "status", default: "active", null: false
    t.uuid "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_saas_accounts_on_plan_id"
    t.index ["slug"], name: "index_saas_accounts_on_slug", unique: true
    t.index ["subdomain"], name: "index_saas_accounts_on_subdomain", unique: true
  end

  create_table "saas_modules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_saas_modules_on_key", unique: true
  end

  create_table "saas_plan_modules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id", null: false
    t.uuid "module_id", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["module_id"], name: "index_saas_plan_modules_on_module_id"
    t.index ["plan_id", "module_id"], name: "index_saas_plan_modules_on_plan_id_and_module_id", unique: true
    t.index ["plan_id"], name: "index_saas_plan_modules_on_plan_id"
  end

  create_table "saas_plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_saas_plans_on_key", unique: true
  end

  create_table "saas_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saas_tenant_databases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "saas_account_id", null: false
    t.string "database_name", null: false
    t.string "username", null: false
    t.string "password", null: false
    t.string "adapter", default: "postgresql", null: false
    t.string "host", default: "localhost"
    t.integer "port", default: 5432
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["database_name"], name: "index_saas_tenant_databases_on_database_name", unique: true
    t.index ["saas_account_id"], name: "index_saas_tenant_databases_on_saas_account_id"
  end

  create_table "saas_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "saas_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_saas_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_saas_users_on_reset_password_token", unique: true
    t.index ["saas_role_id"], name: "index_saas_users_on_saas_role_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "core_addresses", "master_data_address_types", column: "address_type_id"
  add_foreign_key "core_addresses", "master_data_countries", column: "country_id"
  add_foreign_key "core_bank_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_business_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_business_infos", "master_data_tax_types", column: "tax_type_id"
  add_foreign_key "core_entities", "core_companies", column: "company_id"
  add_foreign_key "core_entities", "master_data_entity_types", column: "entity_type_id"
  add_foreign_key "core_personal_infos", "core_entities", column: "entity_id"
  add_foreign_key "core_personal_infos", "master_data_document_types", column: "document_type_id"
  add_foreign_key "core_subscriptions", "core_companies", column: "company_id"
  add_foreign_key "core_subscriptions", "saas_modules", column: "module_id"
  add_foreign_key "core_user_roles", "core_companies", column: "company_id", on_delete: :cascade
  add_foreign_key "core_user_roles", "core_users", column: "user_id", on_delete: :cascade
  add_foreign_key "core_user_roles", "master_data_roles", column: "role_id", on_delete: :cascade
  add_foreign_key "core_users", "core_companies", column: "company_id", on_delete: :cascade
  add_foreign_key "core_users", "core_entities", column: "entity_id"
  add_foreign_key "saas_accounts", "saas_plans", column: "plan_id"
  add_foreign_key "saas_plan_modules", "saas_modules", column: "module_id"
  add_foreign_key "saas_plan_modules", "saas_plans", column: "plan_id"
  add_foreign_key "saas_tenant_databases", "saas_accounts"
  add_foreign_key "saas_users", "saas_roles"
end
