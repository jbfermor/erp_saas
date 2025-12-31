module Core
  class Company < ApplicationRecord

    has_many :entities, class_name: "Core::Entity", dependent: :destroy
    has_many :users, class_name: "Core::User", dependent: :destroy
    has_many :company_plans,
         class_name: "Core::CompanyPlan",
         dependent: :destroy
    has_many :plans,
            through: :company_plans, class_name: "Core::Plan"

    has_one :business_info, class_name: "Contact::BusinessInfo", dependent: :destroy
    has_one :bank_info, class_name: "Contact::BankInfo", dependent: :destroy
    has_one :database_config, class_name: "MasterData::DatabaseConfig", dependent: :destroy

    validates :name, :saas_account_id, presence: true
    validates :slug, presence: true, uniqueness: true
  end
end
