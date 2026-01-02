class CreateMasterDataEntityRoleAssignmentStates < ActiveRecord::Migration[8.0]
  def change
    create_table :master_data_entity_role_assignment_states, id: :uuid do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
