# == Schema Information
# Table name: core_personal_infos
#  entity_id        :integer
#  document_type_id :integer
#  first_name       :string
#  last_name        :string
#  document_number  :string
#
class Core::PersonalInfo < ApplicationRecord
  belongs_to :entity, class_name: "Core::Entity"
  belongs_to :document_type, class_name: "Saas::DocumentType", optional: true

  validates :first_name, :last_name, presence: true, unless: -> { entity&.business_info.present? }

  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
