class Tenant::SubscriptionSetupService
  def initialize(company, plan)
    @company = company
    @plan = plan
  end

  def call
    @plan.modules.find_each do |mod|
      Core::Subscription.find_or_create_by!(
        company: @company,
        module: mod,
        active: true
      ) 
    end
  end
end
