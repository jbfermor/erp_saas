module Core
  class Company < ApplicationRecord

    has_many :entities, class_name: "Core::Entity", dependent: :destroy
    has_many :users, class_name: "Core::User", dependent: :destroy
    has_many :company_plans,
         class_name: "MasterData::CompanyPlan",
         dependent: :destroy

    has_one :current_company_plan,
            -> { order(created_at: :desc) },
            class_name: "MasterData::CompanyPlan"

    has_one :plan,
            through: :current_company_plan

    validates :name, :saas_account_id, presence: true
    validates :slug, presence: true, uniqueness: true
  end
end
