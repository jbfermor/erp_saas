module Saas
  class Role < ApplicationRecord
    belongs_to :account, class_name: "Saas::Account"
    has_many :user_roles, class_name: "Core::UserRole", dependent: :destroy
    has_many :users, through: :user_roles, class_name: "Core::User"

    validates :name, :slug, presence: true, uniqueness: true
  end
end
