FactoryBot.define do
  factory :answer do
    title { "MyString" }
    body { "MyText" }
    question { Question.new(title: "meow", body: "meow") }
  end
end
