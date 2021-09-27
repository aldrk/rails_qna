feature 'User can add links to answer', "
  In order to provide additional to answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://github.com/aldrk/rails_qna' }

  scenario 'User adds link when answer', :js do
    sign_in(user)

    visit question_path(question)

    fill_in 'Title', with: 'MyAnswerTitle'
    fill_in 'Body', with: 'MyAnswerBody'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end