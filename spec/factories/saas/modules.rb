FactoryBot.define do
  factory :saas_module, class: 'Saas::Module' do
    sequence(:name) { |n| "Module #{n}" }
    sequence(:key)  { |n| "module_#{n}" }
    description { "A functional SaaS module." }
    active { true }
  end
end
