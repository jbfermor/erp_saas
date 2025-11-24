# == Schema Information
# Table name: core_entity_types
#  name      :string
#  code      :string
#  system    :boolean
#
module MasterData
  class EntityType < ApplicationRecord
    has_many :entities, class_name: "Core::Entity", dependent: :nullify

    validates :name, presence: true

    scope :system_defined, -> { where(system: true) }
  end
end
