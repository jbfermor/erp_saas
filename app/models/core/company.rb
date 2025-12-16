module Core
  class Company < ApplicationRecord
    self.table_name = "core_companies"


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

    has_one :business_info, class_name: "Core::BusinessInfo", dependent: :destroy
    has_one :bank_info, class_name: "Core::BankInfo", dependent: :destroy
    
    has_one :database_config, class_name: "MasterData::DatabaseConfig", dependent: :destroy

    validates :name, :saas_account_id, presence: true
    validates :slug, presence: true, uniqueness: true
  end
end
