require 'rails_helper'

feature 'User can change the question', "
  In order to edit question
  As an authenticated user
  I'd like to be able change the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', :js do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        expect(page).to have_selector '#question_title'
        fill_in 'Body', with: 'edited question'
        click_on 'Save'

        expect(page).not_to have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).not_to have_selector '#question_title'
      end
    end

    scenario 'edits question with attached files', :js do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'remove attached file', :js do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'

        click_on 'Remove'

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end

    scenario 'edits his question with errors', :js do
      sign_in(user)
      visit root_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_selector '#question_title'
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