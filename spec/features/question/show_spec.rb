feature 'User can open the question', "
  In order to find answer
  As an unauthenticated user
  I'd like to be able open the question
" do
  let!(:answer) { create(:answer) }

  scenario 'user open questions list' do
    visit question_path(answer.question)

    expect(page).to have_content answer.title
    expect(page).to have_content answer.body
    expect(page).to have_content answer.question.title
    expect(page).to have_content answer.question.body
  end
end