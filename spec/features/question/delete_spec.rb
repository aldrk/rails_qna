feature 'User can remove the question', "
  In order to cancel question
  As an authenticated user
  I'd like to be able remove the question
" do
  given(:user) { create(:user) }

  background do
    create(:question, author: user)
    visit root_path
  end

  scenario 'author tries to destroy question', js: true do
    sign_in(user)
    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionBody'
    click_on 'Delete'

    expect(page).not_to have_content 'MyQuestionTitle'
    expect(page).not_to have_content 'MyQuestionBody'

    expect(page).to have_content 'Question was destroyed'
  end

  scenario 'unauthenticated user tries to destroy question' do
    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionBody'

    expect(page).not_to have_content 'Delete question'
  end

  scenario 'not author tries to destroy question' do
    sign_in(create(:user))

    expect(page).not_to have_content 'Delete question'
  end
end