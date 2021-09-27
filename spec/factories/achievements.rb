FactoryBot.define do
  factory :achievement do
    description { "MyAchievement" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/achievement_test.png") }
    question
  end
end