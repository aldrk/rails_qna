class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully posted.'
    else
      render 'questions/show'
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

  private

  def answer_params
    params.require(:answer).permit(:title, :body)
  end
end