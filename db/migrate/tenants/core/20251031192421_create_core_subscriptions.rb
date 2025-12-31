class CreateCoreSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :core_subscriptions, id: :uuid do |t|
      t.references :company, null: false, foreign_key: { to_table: :core_companies }, type: :uuid
      t.references :module,  null: false, foreign_key: { to_table: :master_data_modules }, type: :uuid
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
