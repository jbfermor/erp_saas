FactoryBot.define do
  factory :master_data_database_config, class: 'MasterData::DatabaseConfig' do
    company { nil }
    host { "MyString" }
    port { "MyString" }
    database_name { "MyString" }
    username { "MyString" }
    password { "MyString" }
  end
end
