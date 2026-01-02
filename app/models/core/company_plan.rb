module Core
  class CompanyPlan < ApplicationRecord

    self.table_name = "core_company_plans"

    belongs_to :company, class_name: "Core::Company", foreign_key: "company_id", dependent: :destroy
    belongs_to :plan, class_name: "MasterData::Plan", foreign_key: "plan_id", dependent: :destroy
    
    validates :active, presence: true

    after_create :create_subscriptions

    private

    def create_subscriptions
      Tenant::SubscriptionSetupService.new(self.company, self.plan).call
    end
  end
end
