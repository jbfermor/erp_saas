class CreateMasterDataModules < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_modules, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :description

      t.timestamps
    end
  end
end
