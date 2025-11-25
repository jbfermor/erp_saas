class CreateMasterDataCompanyPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_company_plans, id: :uuid do |t|
      t.references :core_company, null: false, foreign_key: { to_table: :core_company }, type: :uuid
      t.references :master_data_plan, null: false, foreign_key: { to_table: :master_data_plans }, type: :uuid

      t.timestamps
    end

    add_index :master_data_company_plans, [:core_company_id, :master_data_plan_id], unique: true

  end
end
