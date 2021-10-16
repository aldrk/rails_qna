class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :nominate]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      QuestionSubscriptionJob.perform_now(@question)
      flash[:notice] = 'Your answer successfully posted.'
    else
      flash[:alert] = 'You need to sign in or sign up before continuing.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if can?(:manage, @answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted'
    else
      redirect_to question_path(@answer.question), alert: 'You are not a author!'
    end
  end

  def update
    @answer.update(answer_params)
  end

  def nominate
    authorize! :nominate, @answer

    @question = @answer.question
    @answer.choose_best_answer
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, files: [], links_attributes: [:name, :url])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      'answers',
      {
        answer: @answer,
        current_user: current_user,
        create_comment_token: form_authenticity_token
      }.to_json
    )
  end
end