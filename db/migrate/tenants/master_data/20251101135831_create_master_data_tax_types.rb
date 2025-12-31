class CreateMasterDataTaxTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :master_data_tax_types , id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.boolean :system

      t.timestamps
    end
  end
end
