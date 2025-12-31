# frozen_string_literal: true

class DeviseCreateCoreUsers < ActiveRecord::Migration[8.0]
  def up
    create_table :core_users, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Referencias SIN autoload
      t.uuid :role_id, null: false
      t.uuid :company_id, null: false
      t.uuid :entity_id

      t.string :slug

      t.timestamps null: false
    end

    add_index :core_users, :email,                unique: true
    add_index :core_users, :reset_password_token, unique: true

    # Foreign keys (no autoload)
    add_foreign_key :core_users, :master_data_roles, column: :role_id
    add_foreign_key :core_users, :core_companies, column: :company_id, on_delete: :cascade
    add_foreign_key :core_users, :core_entities, column: :entity_id
  end

  def down
    drop_table :core_users, if_exists: true
  end
end
