class QuestionSubscriptionPreview < ActionMailer::Preview
  def digest
    DailyDigestMailer.digest
  end
end