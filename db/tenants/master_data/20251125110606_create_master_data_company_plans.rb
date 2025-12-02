class CreateMasterDataCompanyPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :master_data_company_plans, id: :uuid do |t|
      t.references :company, null: false, foreign_key: { to_table: :core_companies }, type: :uuid
      t.references :plan, null: false, foreign_key: { to_table: :master_data_plans }, type: :uuid

      t.timestamps
    end

    add_index :master_data_company_plans, [:company_id, :plan_id], unique: true

  end
end
