class CreateCoreUserRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :core_user_roles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: { to_table: :core_users, on_delete: :cascade }, type: :uuid
      t.references :role, null: false, foreign_key: { to_table: :saas_roles, on_delete: :cascade }, type: :uuid
      t.references :company, null: false, foreign_key: { to_table: :core_companies, on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :core_user_roles, [:user_id, :role_id, :company_id], unique: true, name: 'index_user_roles_unique'
  end
end
