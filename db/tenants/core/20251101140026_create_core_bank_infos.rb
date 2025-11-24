class CreateCoreBankInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :core_bank_infos, id: :uuid do |t|
      t.references :entity, null: false, foreign_key: { to_table: :core_entities }, type: :uuid
      t.string :bank_name
      t.string :iban
      t.string :swift
      t.boolean :is_default
      t.string :slug, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
