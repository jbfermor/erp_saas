class CreateContactEntityRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_entity_roles, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.boolean :system, default: false, null: false

      t.timestamps
    end
  end
end
