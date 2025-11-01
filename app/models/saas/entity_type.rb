# == Schema Information
# Table name: core_entity_types
#  name      :string
#  code      :string
#  system    :boolean
#
class Saas::EntityType < ApplicationRecord
  has_many :entities, class_name: "Core::Entity", dependent: :nullify

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  scope :system_defined, -> { where(system: true) }
end
