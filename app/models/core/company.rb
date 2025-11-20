module Core
  class Company < ApplicationRecord

    has_many :entities, class_name: "Core::Entity", dependent: :destroy
    has_many :users, class_name: "Core::User", dependent: :destroy

    validates :name, :saas_account_id, presence: true
    validates :slug, presence: true, uniqueness: true
  end
end
