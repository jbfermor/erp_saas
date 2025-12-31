# app/models/core/entity.rb
module Core
  class Entity < ApplicationRecord
    belongs_to :entity_type, class_name: "MasterData::EntityType"
    belongs_to :company, class_name: "Core::Company"
    belongs_to :parent_entity, class_name: "Core::Entity", optional: true

    has_one :personal_info, class_name: "Contact::PersonalInfo", dependent: :destroy
    has_one :business_info, class_name: "Contact::BusinessInfo", dependent: :destroy
    
    has_many :addresses, as: :addressable, class_name: "Contact::Address", dependent: :destroy
    has_many :bank_infos, class_name: "Contact::BankInfo", dependent: :destroy
    has_many :child_entities, class_name: "Core::Entity", foreign_key: :parent_entity_id, dependent: :nullify
    has_many :entity_role_assignments, class_name: "Contact::EntityRoleAssignment", dependent: :destroy
    has_many :entity_roles, through: :entity_role_assignments, class_name: "Contact::EntityRole"

    # 🆕 AÑADIR: Obtener la dirección de trabajo
    def work_address
      addresses.joins(:address_type).find_by(master_data_address_types: { slug: 'work' })
    end

    # 🆕 AÑADIR: Verificar si tiene dirección de trabajo
    def work_address?
      work_address.present?
    end
  end
end