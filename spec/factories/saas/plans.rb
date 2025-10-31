FactoryBot.define do
  factory :saas_plan, class: 'Saas::Plan' do
    sequence(:name) { |n| "Plan #{n}" }
    sequence(:key)  { |n| "plan_#{n}" }
    description { "A SaaS plan with various modules." }
    active { true }
  end
end
