FactoryBot.define do
  factory :core_bank_info, class: 'Core::BankInfo' do
    entity { nil }
    bank_name { "MyString" }
    iban { "MyString" }
    swift { "MyString" }
    is_default { false }
  end
end
