class CreateSaasRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :saas_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
