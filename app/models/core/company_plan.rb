module Core
  class CompanyPlan < ApplicationRecord
    self.table_name = "master_data_company_plans"

    belongs_to :company, class_name: "Core::Company", foreign_key: "core_company_id"
    belongs_to :plan, class_name: "MasterData::Plan", foreign_key: "master_data_plan_id"
    
    after_create :create_subscriptions

    private

    def create_subscriptions
      Tenant::SubscriptionSetupService.new(company, plan).call
    end
  end
end
