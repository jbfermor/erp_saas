FactoryBot.define do
  factory :core_subscription, class: "Core::Subscription" do
    association :company, factory: :core_company
    association :module,  factory: :saas_module
    status { "active" }
  end
end
