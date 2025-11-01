FactoryBot.define do
  factory :core_entity, class: "Core::Entity" do
    slug { SecureRandom.uuid }
    association :company, factory: :core_company
    association :entity_type, factory: [:saas_entity_type, :individual]

    trait :with_personal_info do
      after(:create) do |entity|
        create(:core_personal_info, entity: entity)
      end
    end

    trait :with_business_info do
      after(:create) do |entity|
        create(:core_business_info, entity: entity)
      end
    end
  end
end
