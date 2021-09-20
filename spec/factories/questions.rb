FactoryBot.define do
  factory :question do
    title { 'MyTitle' }
    body { 'MyBody' }
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
