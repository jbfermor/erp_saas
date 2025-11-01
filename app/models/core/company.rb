module Core
  class Company < ApplicationRecord
    belongs_to :saas_account, class_name: "Saas::Account"

    has_many :entities, class_name: "Core::Entity", dependent: :destroy
    has_many :users, class_name: "Core::User", dependent: :destroy

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
  end
end
