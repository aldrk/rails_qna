
class QuestionSubscriptionMailer < ApplicationMailer
  def digest(user)
    mail to: user.email
  end
end