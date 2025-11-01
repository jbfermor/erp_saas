class CreateCoreCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :core_companies, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.references :saas_account, null: false, foreign_key: { to_table: :saas_accounts }, type: :bigint
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
