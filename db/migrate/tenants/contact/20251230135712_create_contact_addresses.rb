class CreateContactAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_addresses, id: :uuid do |t|
      t.references :addressable, polymorphic: true, null: false
      t.references :address_type, null: false, foreign_key: { to_table: :master_data_address_types }, type: :uuid
      t.references :country, null: false, foreign_key: { to_table: :master_data_countries }, type: :uuid
      t.string :street
      t.string :city
      t.string :postal_code
      t.string :province
      t.string :slug, null: false, index: { unique: true }
      
      t.timestamps
    end
  end
end
