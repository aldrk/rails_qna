FactoryBot.define do
  factory :answer do
    title { 'MyTitle' }
    body { 'MyBody' }
    association :author, factory: :user
    question

    trait :invalid do
      title { nil }
    end
  end
end