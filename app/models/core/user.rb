module Core
  class User < ApplicationRecord
    devise :database_authenticatable, :recoverable, :rememberable, :validatable

    belongs_to :company, class_name: "Core::Company"
    belongs_to :entity, class_name: "Core::Entity", optional: true
    belongs_to :role, class_name: "MasterData::Role", optional: true

    validates :email, presence: true, uniqueness: true

    scope :non_system, -> {
      where.not(role: MasterData::Role.find_by(slug: "system")&.id)
    }

    
  end
end
