feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able ask the question
" do
  given(:user) { create(:user) }

  describe 'authenticated user' do
    background do
      sign_in(user)

      visit root_path
      click_on 'Ask question'
    end

    scenario 'asks a question', js: true do
      fill_in 'Title', with: 'MyQuestionTitle'
      fill_in 'Body', with: 'MyQuestionBody'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'MyQuestionTitle'
      expect(page).to have_content 'MyQuestionBody'
    end

    scenario 'asks a question with errors', js: true do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files', js: true do
      fill_in 'Title', with: 'MyTitle'
      fill_in 'Body', with: 'MyBody'

      attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'unauthenticated user tries to ask a question' do
    visit root_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end