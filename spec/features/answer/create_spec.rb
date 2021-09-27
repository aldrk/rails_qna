
feature 'User can answer the question', "
  In order to help some other user
  As an authenticated user
  I'd like to be able answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', :js do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Title', with: 'MyAnswerTitle'
      fill_in 'Body', with: 'MyAnswerBody'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully posted.'
      expect(page).to have_content 'MyAnswerTitle'
      expect(page).to have_content 'MyAnswerBody'
    end

    scenario 'answers a question with attached files' do
      fill_in 'Title', with: 'Test answer'
      fill_in 'Body', with: 'test test test'

      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'unauthenticated user tries to answer the question' do
    visit question_path(question)
    fill_in 'Title', with: 'MyAnswerTitle'
    fill_in 'Body', with: 'MyAnswerBody'
    click_on 'Answer'

    expect(page).not_to have_content 'You need to sign in or sign up before continuing.'
  end

end