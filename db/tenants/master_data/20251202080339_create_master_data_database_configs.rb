class CreateMasterDataDatabaseConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :master_data_database_configs, id: :uuid do |t|
      t.references :company, null: false, 
      type: :uuid, foreign_key: { to_table: :core_companies }

      t.string :host, null: false
      t.integer :port, null: false
      t.string :database_name, null: false
      t.string :username, null: false
      t.text :password, null: false

      t.timestamps
    end
  end
end
