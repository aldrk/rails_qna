include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { 'MyQuestionTitle' }
    body { 'MyQuestionBody' }
    association :author, factory: :user

    trait :with_files do
      files { [Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb"), Rack::Test::UploadedFile.new("#{Rails.root}/spec/spec_helper.rb")] }
    end

    trait :invalid do
      title { nil }
    end

    trait :with_achievement do
      achievement
    end
  end
end
