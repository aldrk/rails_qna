class QuestionSubscriptionService
  def send_digest(question)
    QuestionSubscription.where(question: question).find_each(batch_size: 500) do |subscription|
      QuestionSubscriptionMailer.digest(subscription.user).deliver_later
    end
  end
end