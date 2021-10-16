RSpec.describe QuestionSubscriptionService, type: :service do
  let(:question) { create(:question) }
  let(:question_subscription) { create_list(:question_subscription, 3, question: question) }

  it 'sends digest to all subscribers' do
    question_subscription.each { |subscription| expect(QuestionSubscriptionMailer).to receive(:digest).with(subscription.user).and_call_original }
    subject.send_digest(question)
  end
end