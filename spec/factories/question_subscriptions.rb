FactoryBot.define do
  factory :question_subscription do
    association :question
    association :user
  end
end