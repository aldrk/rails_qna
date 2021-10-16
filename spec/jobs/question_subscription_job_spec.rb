RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:question) { create(:question) }
  let(:service) { double('QuestionSubscriptionService') }

  before do
    allow(QuestionSubscriptionService).to receive(:new).and_return(service)
  end

  it 'calls QuestionSubscriptionService#send_digest' do
    expect(service).to receive(:send_digest)
    QuestionSubscriptionJob.perform_now(question)
  end
end