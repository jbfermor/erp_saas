module Contact
  class EntityRole < ApplicationRecord
    has_many :entity_role_assignments,
             dependent: :destroy
    has_many :entities,
             through: :entity_role_assignments

    validates :name, :slug, presence: true
    validates :slug, uniqueness: true

    scope :system, -> { where(system: true) }
    scope :custom, -> { where(system: false) }
  end
end
