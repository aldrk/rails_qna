class QuestionSubscriptionJob < ApplicationJob
  queue_as :default

  def perform(question)
    QuestionSubscriptionService.new.send_digest(question)
  end
end