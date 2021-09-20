FactoryBot.define do
  factory :answer do
    title { 'MyAnswerTitle' }
    body { 'MyAnswerBody' }
    association :author, factory: :user
    question

    trait :invalid do
      title { nil }
    end
  end
end