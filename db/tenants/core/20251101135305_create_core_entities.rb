class CreateCoreEntities < ActiveRecord::Migration[8.0]
  def change
    create_table :core_entities, id: :uuid do |t|
      t.references :entity_type, null: false, foreign_key: { to_table: :master_data_entity_types }, type: :uuid
      t.references :company, null: false, foreign_key: { to_table: :core_companies }, type: :uuid

      t.timestamps
    end
  end
end
