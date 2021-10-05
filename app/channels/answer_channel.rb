class AnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'answers'
  end

  def unsubscribed; end
end