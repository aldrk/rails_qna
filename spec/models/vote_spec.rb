RSpec.describe Vote, type: :model do
  describe '#liked_from?' do
    subject(:resource) { create(:question) }
    let(:user) { create(:user) }
    before { create(:vote, votable: resource, author: user) }

    context 'when user like question' do
      it { is_expected.to be_liked_from(user) }
    end

    context 'when user dont like question' do
      it { is_expected.not_to be_liked_from(create(:user)) }
    end
  end

  describe '#vote_from' do
    let(:resource) { create(:question) }
    let(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: resource, author: user) }

    context 'when user like question' do
      it { expect(resource.vote_from(user).id).to eq vote.id }
    end

    context 'when user dont like question' do
      it { expect(resource.vote_from(user).id).not_to eq create(:vote, votable: resource).id }
    end
  end

  describe '#total_votes' do
    let(:resource) { create(:question) }

    context 'when question got up votes and down votes' do
      before do
        create(:vote, votable: resource)
        create(:vote, votable: resource)
        create(:vote, votable: resource, liked: false)
      end

      it { expect(resource.total_votes).to eq 1 }
    end

    context 'when question got up votes only' do
      before do
        create(:vote, votable: resource)
      end

      it { expect(resource.total_votes).to eq 1 }
    end

    context 'when question got down votes only' do
      before do
        create(:vote, votable: resource, liked: false)
      end

      it { expect(resource.total_votes).to eq -1 }
    end

    context 'when question dont have any votes' do
      it { expect(resource.total_votes).to eq 0 }
    end
  end
end