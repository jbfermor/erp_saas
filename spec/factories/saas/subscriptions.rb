FactoryBot.define do
  factory :saas_subscription, class: "Saas::Subscription" do
    association :account, factory: :saas_account
    association :module, factory: :saas_module
    started_at { Time.current }
    expires_at { 30.days.from_now }
    status { "active" }
    auto_renew { true }
  end
end