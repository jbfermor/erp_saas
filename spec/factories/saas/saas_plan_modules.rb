FactoryBot.define do
  factory :saas_plan_module, class: 'Saas::PlanModule' do
    association :plan, factory: :saas_plan
    association :module, factory: :saas_module
    enabled { true }
  end
end
