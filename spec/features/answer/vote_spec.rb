feature 'User can vote for question', "
  In order to identify a best question
  As an authenticated user
  I'd like to be vote for question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    create(:answer, question: question)
    visit question_path(question)
  end

  scenario 'User voted for a liked question', :js do
    expect(page).not_to have_content 'Cancel vote'

    click_on 'Like'

    expect(page).to have_content 'Cancel vote'
  end

  scenario 'User voted for a disliked question', :js do
    expect(page).not_to have_content 'Cancel vote'

    click_on 'Dislike'

    expect(page).to have_content 'Cancel vote'
  end

  scenario 'User canceled vote', :js do
    click_on 'Like'
    click_on 'Cancel vote'

    expect(page).to have_content 'Like'
    expect(page).to have_content 'Dislike'
  end
end