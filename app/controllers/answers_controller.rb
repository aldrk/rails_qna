class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: [:destroy, :update, :nominate]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully posted.'
    else
      flash[:alert] = 'You need to sign in or sign up before continuing.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author?(@answer)
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
end