class CreateSaasPlanModules < ActiveRecord::Migration[7.2]
  def change
    create_table :saas_plan_modules do |t|
      t.references :plan, null: false, foreign_key: { to_table: :saas_plans }
      t.references :module, null: false, foreign_key: { to_table: :saas_modules }
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end

    add_index :saas_plan_modules, [:plan_id, :module_id], unique: true
  end
end
