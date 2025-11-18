# app/models/master_data/role.rb
module MasterData
  class Role < ApplicationRecord
    has_many :users, class_name: "Core::User"

    validates :name, :slug, :scope, :position, presence: true
    validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    scope :saas_roles, -> { where(scope: "saas") }
    scope :tenant_roles, -> { where(scope: "tenant") }

    def can_manage?(other_role)
      position < other_role.position
    end

    def to_s
      name
    end
  end
end
