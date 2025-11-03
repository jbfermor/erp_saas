FactoryBot.define do
  factory :core_personal_info, class: 'Core::PersonalInfo' do
    slug { "juan-perez" }
    first_name { "Juan" }
    last_name  { "Pérez" }
    document_number { "12345678A" }

        # 🔹 Asociaciones correctas
    association :document_type, factory: [:master_data_document, :dni]
    association :entity, factory: :core_entity
  end
end
