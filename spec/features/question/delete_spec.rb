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

  scenario 'author tries to destroy question' do
    sign_in(user)

    click_on 'Delete'

    expect(page).to have_content 'Question was destroyed'
  end

  scenario 'not a author tries to delete question' do
    sign_in(create(:user))
    visit root_path
    click_on 'Delete'

    expect(page).to have_content 'You can`t do that'
  end

  scenario 'unauthenticated user tries to delete question' do
    click_on 'Delete'

    expect(page).to have_content 'Log in'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end