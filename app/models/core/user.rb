module Core
  class User < ApplicationRecord
    devise :database_authenticatable, :recoverable, :rememberable, :validatable

    belongs_to :company, class_name: "Core::Company"
    belongs_to :entity, class_name: "Core::Entity", optional: true
    has_many :user_roles, class_name: "Core::UserRole", dependent: :destroy
    has_many :roles, through: :user_roles, class_name: "MasterData::Role"

    validates :email, presence: true, uniqueness: true

    scope :non_system, -> {
      where.not(id: joins(:roles).where(master_data_roles: { name: 'System' }))
    } 
    
   end
end
