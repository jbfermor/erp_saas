class CreateSaasTaxTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :saas_tax_types , id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.string :slug, null: false, index: { unique: true }
      t.boolean :system

      t.timestamps
    end
  end
end
