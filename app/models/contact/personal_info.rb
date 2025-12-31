module Contact
  class PersonalInfo < ApplicationRecord
    belongs_to :entity, class_name: "Core::Entity"
    belongs_to :document_type, class_name: "MasterData::DocumentType", optional: true

    validates :first_name, :last_name, presence: true, unless: -> { entity&.business_info.present? }

    def full_name
      [first_name, last_name].compact.join(" ")
    end
  end
end 
