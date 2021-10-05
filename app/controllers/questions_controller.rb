class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
    @question = Question.new
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_achievement
  end

  def show
    @answer = Answer.new
    @answer.links.build
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
    params.require(:question).permit(:title, :body, files: [], achievement_attributes: [:description, :image], links_attributes: [:name, :url, :_destroy])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      {
        question: @question,
        current_user: current_user,
        create_comment_token: form_authenticity_token
      }.to_json
    )
  end
end