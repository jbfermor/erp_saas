# app/models/core/address.rb
module Core
  class Address < ApplicationRecord
    belongs_to :addressable, polymorphic: true, inverse_of: :addresses
    belongs_to :address_type, class_name: "MasterData::AddressType"
    belongs_to :country, class_name: "MasterData::Country"

    validates :street, :city, :postal_code, presence: true
    
    # 🆕 AÑADIR: Validar que solo exista una dirección de tipo "work" por Entity
    validates :address_type_id, uniqueness: { 
      scope: [:addressable_type, :addressable_id],
      conditions: -> { joins(:address_type).where(master_data_address_types: { slug: 'work' }) },
      message: "ya existe una dirección de trabajo para esta entidad"
    }, if: :work_address?

    # 🆕 Helper para detectar si es dirección de trabajo
    def work_address?
      address_type&.slug == 'work'
    end
  end
end