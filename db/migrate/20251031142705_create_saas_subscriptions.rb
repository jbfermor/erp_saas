class CreateCoreSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :core_subscriptions do |t|
      t.references :company, null: false, foreign_key: { to_table: :core_companies }
      t.references :module,  null: false, foreign_key: { to_table: :saas_modules }
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :status, default: "active"

      t.timestamps
    end
  end
end
