RSpec.describe Core::Subscription, type: :model do
  it { should belong_to(:company) }
  it { should belong_to(:module) }
  it { should validate_presence_of(:company_id) }
  it { should validate_presence_of(:module_id) }
end
