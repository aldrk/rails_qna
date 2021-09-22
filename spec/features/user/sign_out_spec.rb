feature 'User can sign out', "
  In order to don't save the session
  I'd like to be able to sign out
" do
  scenario 'Logged in user tries to log out' do
    user = create(:user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit root_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'logged out user tries to log out' do
    visit root_path

    expect(page).not_to have_content 'Log out'
  end
end