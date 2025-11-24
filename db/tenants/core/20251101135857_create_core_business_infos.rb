class CreateCoreBusinessInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :core_business_infos, id: :uuid do |t|
      t.references :entity, null: false, foreign_key: { to_table: :core_entities }, type: :uuid
      t.references :tax_type, null: false, foreign_key: { to_table: :master_data_tax_types }, type: :uuid
      t.string :slug, null: false, index: { unique: true }
      t.string :business_name
      t.string :trade_name
      t.string :tax_id
      t.string :registration_number
      t.string :phone
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
