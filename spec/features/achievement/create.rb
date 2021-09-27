feature 'User can add achievement to question', "
  In order to give achievement to user who create best answer
  As an creator of question
  I'd like to be able add achievement to question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:achievement) { create(:achievement, question: question) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'author of question choose your answer', :js do
    sign_in(user)
    visit achievements_path

    expect(page).not_to have_content achievement.description

    visit question_path(question)
    click_on 'Choose as best'
    visit achievements_path

    expect(page).to have_content achievement.description
  end
end