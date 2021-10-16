class QuestionSubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:subscribe, :unsubscribe]

  def subscribe
    subs = QuestionSubscription.new(question: @question, user: current_user)

    if subs.save
      flash[:notice] = 'You are successfully subscribed'
    else
      flash[:alert] = 'Subscribed failed'
    end

    redirect_to root_path
  end

  def unsubscribe
    subs = QuestionSubscription.where(question: @question, user: current_user).first

    if subs.destroy
      flash[:notice] = 'Subscription canceled successful'
    else
      flash[:alert] = 'Subscription canceling failed'
    end

    redirect_to root_path
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
