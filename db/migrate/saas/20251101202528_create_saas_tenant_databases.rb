class CreateSaasTenantDatabases < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_tenant_databases, id: :uuid do |t|
      t.references :saas_account, null: false, foreign_key: { to_table: :saas_accounts }, type: :uuid
      t.string :database_name, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.string :adapter, null: false, default: "postgresql"
      t.string :host, default: "localhost"
      t.integer :port, default: 5432
      t.string :status, default: "active"
      t.timestamps
    end

    add_index :saas_tenant_databases, :database_name, unique: true
  end
end
