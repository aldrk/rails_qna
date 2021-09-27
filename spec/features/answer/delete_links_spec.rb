feature 'Authenticated user can delete answers links', "
  As an answer's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer) { create(:answer, author: user, question: question) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'authenticated user remove answers link', :js do
    sign_in(user)
    visit question_path(question)

    within '.answer' do
      expect(page).to have_link link.name, href: link.url
    end

    click_on 'Delete link'

    within '.answer' do
      expect(page).not_to have_link link.name, href: link.url
    end
  end

  scenario 'unauthenticated user remove answers link' do
    visit question_path(question)

    within '.answer' do
      expect(page).not_to have_link 'Delete link'
    end
  end

  scenario 'not a author remove answers link' do
    sign_in(create(:user))
    visit question_path(question)

    within '.answer' do
      expect(page).not_to have_link 'Delete link'
    end
  end
end