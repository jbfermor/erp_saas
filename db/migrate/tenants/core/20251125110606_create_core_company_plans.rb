class CreateCoreCompanyPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :core_company_plans, id: :uuid do |t|
      t.references :company, null: false, foreign_key: { to_table: :core_companies }, type: :uuid
      t.references :plan, null: false, foreign_key: { to_table: :master_data_plans }, type: :uuid
      t.boolean :active, default: true, null: false
      t.timestamps
    end
  end
end
