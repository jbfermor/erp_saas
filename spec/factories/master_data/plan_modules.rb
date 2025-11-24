FactoryBot.define do
  factory :master_data_plan_module, class: "MasterData::PlanModule" do
    association :plan, factory: :master_data_plan
    association :module, factory: :master_data_module
  end
end
