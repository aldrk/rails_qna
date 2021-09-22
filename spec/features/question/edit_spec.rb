require 'rails_helper'

feature 'User can change the question', "
  In order to edit question
  As an autheticated user
  I'd like to be able change the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end

      within '.question-errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      sign_in(create(:user))

      expect(page).not_to have_content 'Edit'
    end
  end
end