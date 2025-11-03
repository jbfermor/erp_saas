class CreateMasterDataEntityTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_entity_types, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.string :slug, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
