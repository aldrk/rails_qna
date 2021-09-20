feature 'User can browse a questions', "
  In order to find question
  As an unauthenticated user
  I'd like to be able browse a questions
" do
  let!(:question) { create(:question) }

  scenario 'user open questions list' do
    visit root_path

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end