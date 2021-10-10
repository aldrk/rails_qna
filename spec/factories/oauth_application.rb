FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'qna' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '987654321' }
    secret { '987654321' }
  end
end
