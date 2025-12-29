# app/models/core/entity.rb
module Core
  class Entity < ApplicationRecord
    belongs_to :entity_type, class_name: "MasterData::EntityType"
    belongs_to :company, class_name: "Core::Company"

    has_one :personal_info, class_name: "Core::PersonalInfo", dependent: :destroy
    has_one :business_info, class_name: "Core::BusinessInfo", dependent: :destroy
    has_many :addresses, as: :addressable, class_name: "Core::Address", dependent: :destroy
    has_many :bank_infos, class_name: "Core::BankInfo", dependent: :destroy

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