class CreateSaasSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_subscriptions, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { to_table: :saas_accounts }, type: :uuid
      t.references :module, null: false, foreign_key: { to_table: :saas_modules }, type: :uuid
      t.datetime :started_at, null: false
      t.datetime :expires_at
      t.string :status, null: false, default: "active"
      t.boolean :auto_renew, default: true

      t.timestamps
    end

    add_index :saas_subscriptions, [:account_id, :module_id], unique: true
  end
end
