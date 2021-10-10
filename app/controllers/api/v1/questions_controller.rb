class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: [:show, :destroy, :update]

  skip_before_action :verify_authenticity_token
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.created_questions.build(question_params)

    if @question.save
      render json: @question
    else
      render json: { 'alert': 'Question is not created' }
    end
  end

  def destroy
    if can?(:manage, @question)
      @question.destroy
      render json: @question
    else
      render json: { 'alert': 'Question destroy failed' }
    end
  end

  def update
    if can?(:manage, @question)
      @question = Question.find(params[:id])
      @question.update(question_params)
      render json: @question
    else
      render json: { 'alert': 'Question update failed' }
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, achievement_attributes: [:description, :image], links_attributes: [:name, :url, :_destroy])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end