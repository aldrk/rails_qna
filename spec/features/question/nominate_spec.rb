feature 'User can choose the best answer', "
  In order to check answer of question
  As an author of question
  I'd like to be able choose the best answer
" do
  describe 'when authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, author: user) }

    background do
      sign_in(user)
    end

    scenario 'choose the best answer of his question', js: true do
      create(:answer, question: question)
      visit question_path(question)
      click_on 'Choose as best'

      expect(page).not_to have_content 'Choose as best'
      expect(page).to have_content 'Best answer'
    end

    scenario 'choose other answer of his question', js: true do
      create(:answer, question: question, best: true)
      create(:answer, question: question, body: 'second answer')
      visit question_path(question)

      within '.answer:nth-child(2)' do
        click_on 'Choose as best'
      end

      within '.answer:nth-child(1)' do
        expect(page).to have_content 'Best answer'
      end

      within '.answer:nth-child(2)' do
        expect(page).not_to have_content 'Best answer'
      end
    end

    scenario 'choose a best answer of another question' do
      visit question_path(create(:question))

      expect(page).not_to have_content 'Choose as best'
    end
  end

  describe 'when unauthenticated user' do
    scenario "choose a best answer" do
      create(:answer)
      visit question_path(create(:question))

      expect(page).not_to have_content 'Choose as best'
    end
  end
end