class CreateMasterDataCountries < ActiveRecord::Migration[8.0]
  def change
    create_table :master_data_countries, id: :uuid do |t|
      t.string :name, null: false
      t.string :iso_code, null: false, index: { unique: true }
      t.string :phone_prefix, null: false
      t.string :slug, null: false

      t.timestamps
    end
  end
end
