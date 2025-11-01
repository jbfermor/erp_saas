class CreateSaasAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_accounts, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :subdomain, null: false, index: { unique: true }
      t.string :database_name, null: false
      t.string :status, null: false, default: "active"
      t.references :plan, null: false, foreign_key: { to_table: :saas_plans }, type: :uuid

      t.timestamps
    end

  end
end
