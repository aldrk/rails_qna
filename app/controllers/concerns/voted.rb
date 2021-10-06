module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_vote, only: [:vote, :cancel_vote]
  end

  def vote
    if !@vote
      new_vote
    else
      update_vote
    end
  end

  def cancel_vote
    if @vote.present? && can?(:cancel_vote, @vote)
      render json: @vote, vote_count: @resource.total_votes
      @vote.destroy
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def new_vote
    @vote = Vote.new(vote_params)
    @vote.assign_attributes(votable_id: @resource.id, author: current_user)

    if cannot?(:vote, @resource)
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    elsif @vote.save
      render json: @vote
    end
  end

  def update_vote
    @vote.assign_attributes(liked: vote_params[:liked])

    if @vote.save
      render json: @vote
    else
      render json: @vote.errors.full_messages, status: :unprocessable_entity
    end
  end

  def find_resource
    @resource = vote_params[:votable_type].constantize.find(vote_params[:id])
  end

  def find_vote
    find_resource
    @vote = @resource.vote_from current_user
  end

  def vote_params
    params.permit(:id, :liked, :votable_type)
  end
end