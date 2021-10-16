class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    user ||= User.new
    @user = user

    if user.persisted?
      return admin_abilities if user.admin?

      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :vote, Question
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can :manage, [Question, Answer, Comment], author_id: user.id
    can :vote, [Question, Answer]
    can :cancel_vote, Vote, author_id: user.id
    can :nominate, Answer, question: { author_id: user.id }
    can :subscribe, QuestionSubscription
    can :unsubscribe, QuestionSubscription

    cannot :vote, [Question, Answer], author_id: user.id
  end

  def admin_abilities
    user_abilities

    can :manage, :all
  end
end