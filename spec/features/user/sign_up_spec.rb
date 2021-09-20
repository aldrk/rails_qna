feature 'User can sign up', "
  In order to log in
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  scenario 'unregistered user tries to sign up' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'already registered user tries to sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
