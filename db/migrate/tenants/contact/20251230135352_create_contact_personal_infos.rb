class CreateContactPersonalInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_personal_infos, id: :uuid do |t|
      t.references :entity, null: false, foreign_key: { to_table: :core_entities }, type: :uuid
      t.references :document_type, foreign_key: { to_table: :master_data_document_types }, type: :uuid
      t.string :name
      t.string :surnames
      t.string :document_number
      t.date :birth_date
      t.string :phone
      t.string :personal_email
      t.string :slug, null: false, index: { unique: true }
      
      t.timestamps
    end
  end
end
