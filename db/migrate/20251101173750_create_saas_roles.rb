class CreateSaasRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_roles, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :account, null: false, foreign_key: { to_table: :saas_accounts, on_delete: :cascade }, type: :uuid
      t.string :status, default: "active"

      t.timestamps
    end
    add_index :saas_roles, :name, unique: true
    add_index :saas_roles, :slug, unique: true
  end
end
