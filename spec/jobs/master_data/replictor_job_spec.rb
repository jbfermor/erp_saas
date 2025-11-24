require "rails_helper"

RSpec.describe MasterData::ReplicatorJob, type: :job do
  include ActiveJob::TestHelper

  let(:m) { create(:master_data_module) }

  it "enqueues a job when module is created" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      create(:master_data_module, key: "xmod", name: "X Module")
    }.to have_enqueued_job(MasterData::ReplicatorJob)
  end

  it "performs without blowing up (no tenant DBs present)" do
    expect {
      described_class.new.perform("MasterData::Module", m.id, action: "upsert")
    }.not_to raise_error
  end
end
