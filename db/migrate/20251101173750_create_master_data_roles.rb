class CreateMasterDataRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_roles, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :scope, null: false, index: true
      t.integer :position, null: false, default: 5
      t.timestamps

      t.timestamps
    end
  end
end
