RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :vote, Comment }
    it { should be_able_to :vote, Answer }
    it { should be_able_to :cancel_vote, create(:vote, author: user), author: user }
    it { should be_able_to :manage, create(:question, author: user), author: user }
    it { should be_able_to :manage, create(:answer, author: user), author: user }
    it { should be_able_to :manage, create(:comment, author: user), author: user }
    it { should be_able_to :nominate, create(:answer, question: create(:question, author: user)), author: user }

    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :cancel_vote, create(:vote, author: other), author: user }
    it { should_not be_able_to :manage, create(:question, author: other), author: user }
    it { should_not be_able_to :manage, create(:answer, author: other), author: user }
    it { should_not be_able_to :manage, create(:comment, author: other), author: user }
    it { should_not be_able_to :nominate, create(:answer, question: create(:question, author: other)), author: user }
    it { should_not be_able_to :vote, create(:vote, author: user), author: user }
    it { should_not be_able_to :vote, create(:vote, author: user), author: user }
    it { should be_able_to :subscribe, QuestionSubscription }
    it { should be_able_to :unsubscribe, QuestionSubscription }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end
end