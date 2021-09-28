FactoryBot.define do
  factory :vote do
    author { create(:user) }
    votable { create(:question) }
    liked { true }
  end
end
