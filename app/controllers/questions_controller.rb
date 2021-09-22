class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  def index
    @questions = Question.all
    @question = Question.new
  end

  def new
    @question = Question.new
  end

  def show
    @answer = Answer.new
  end

  def create
    @question = current_user.created_questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :create
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'Question was destroyed'
    else
      flash[:alert] = 'You are not a author!'
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end