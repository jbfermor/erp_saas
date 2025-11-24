class CreateMasterDataPlanModules < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_plan_modules, id: :uuid do |t|
      t.references :master_data_plan, null: false, foreign_key: { to_table: :master_data_plans }, type: :uuid
      t.references :master_data_module, null: false, foreign_key: { to_table: :master_data_modules }, type: :uuid

      t.timestamps
    end

    add_index :master_data_plan_modules, [:master_data_plan_id, :master_data_module_id], unique: true
  end
end
