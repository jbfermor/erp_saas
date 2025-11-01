FactoryBot.define do
  factory :saas_document_type, class: "Saas::DocumentType" do
    sequence(:name) { |n| "Tipo documento #{n}" }
    sequence(:code) { |n| "DOC#{n}" }
    sequence(:slug) { |n| "tipo-documento-#{n}" }

    trait :dni do
      name { "Documento Nacional de Identidad" }
      code { "DNI" }
      slug { "dni" }
    end

    trait :nie do
      name { "Número de Identificación de Extranjero" }
      code { "NIE" }
      slug { "nie" }
    end
  end
end
