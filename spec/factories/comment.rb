FactoryBot.define do
  factory :comment do
    author { create(:user) }
    commentable { create(:question) }
    body { "TestComment" }
  end

  trait :invalid do
    body { nil }
  end
end