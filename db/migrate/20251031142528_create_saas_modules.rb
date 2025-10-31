class CreateSaasModules < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_modules do |t|
      t.string :name, null: false
      t.string :key, null: false, index: { unique: true }
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
