feature 'Authenticated user can delete questions links', "
  As an question's author
  I'd like to be able to delete links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'Authenticated user remove questions link', :js do
    sign_in(user)
    visit question_path(question)

    save_and_open_page

    expect(page).to have_link link.name, href: link.url

    click_on 'Delete link'

    expect(page).not_to have_link link.name, href: link.url
  end

  scenario 'Unauthenticated user remove questions link' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end

  scenario 'Not a author remove questions link' do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).not_to have_link 'Delete link'
  end
end