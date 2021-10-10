class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: [:show, :destroy, :update]

  skip_before_action :verify_authenticity_token
  authorize_resource

  def show
    render json: @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    if @answer.save
      render json: @answer
    else
      render json: { 'alert': 'Answer is not created' }
    end
  end

  def destroy
    if can?(:manage, @answer)
      @answer.destroy
      render json: @answer
    else
      render json: { 'alert': 'Answer destroy failed' }
    end
  end

  def update
    if can?(:manage, @answer)
      @answer = Answer.find(params[:id])
      @answer.update(answer_params)
      render json: @answer
    else
      render json: { 'alert': 'Answer update failed' }
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:title, :body, achievement_attributes: [:description, :image], links_attributes: [:name, :url, :_destroy])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
