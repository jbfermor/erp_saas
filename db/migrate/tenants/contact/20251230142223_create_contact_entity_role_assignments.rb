class CreateContactEntityRoleAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_entity_role_assignments, id: :uuid do |t|
      t.references :entity, null: false, foreign_key: { to_table: :core_entities }, type: :uuid
      t.references :entity_role, null: false, foreign_key: { to_table: :contact_entity_roles }, type: :uuid

      t.timestamps
    end
  end
end
