class CreateContactBusinessInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_business_infos, id: :uuid do |t|
      t.references :entity, null: false, foreign_key: { to_table: :core_entities }, type: :uuid
      t.string :slug, null: false, index: { unique: true }
      t.string :business_name
      t.string :trade_name
      t.string :registration_number
      t.string :phone
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
