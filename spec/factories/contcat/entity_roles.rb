FactoryBot.define do
  factory :contcat_entity_role, class: 'Contcat::EntityRole' do
    company { nil }
    name { "MyString" }
    slug { "MyString" }
    system { false }
  end
end
