describe 'votable' do
  module Votable; end

  context 'with question' do
    with_model :Question do
      model do
        include Votable
      end
    end

    let(:user) { create(:user) }
    subject { Question.create }

    it { is_expected.to have_many(:votes).dependent(:destroy) }

    it 'has module' do
      expect(Question.include?(Votable)).to eq true
    end
  end
end