class CreateMasterDataPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_plans, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
