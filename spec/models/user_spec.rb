RSpec.describe User, type: :model do
  it { is_expected.to have_many(:created_answers).dependent(:destroy) }
  it { is_expected.to have_many(:created_questions).dependent(:destroy) }
  it { is_expected.to have_many(:achievements).dependent(:destroy) }
  it { is_expected.to have_many(:subscribed_questions).through(:question_subscription).source(:question).dependent(:destroy) }

  describe '#author?' do
    subject(:user) { create(:user) }

    context 'when user is the author' do
      let(:resource) { create(:question, author: user) }

      it { is_expected.to be_author(resource) }
    end

    context 'when user is not the author' do
      let(:resource) { create(:question) }

      it { is_expected.not_to be_author(resource) }
    end
  end
end
