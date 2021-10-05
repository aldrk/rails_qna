Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root to: 'questions#index'

  resources :questions, only: %i[new create show destroy update] do
    resources :answers, shallow: true, only: %i[create show destroy update] do
      member do
        patch :nominate
        put :vote, votable_type: 'Answer'
        delete :cancel_vote, votable_type: 'Answer'
      end

      resources :files, shallow: true, only: %i[] do
        delete :answer_destroy
      end
    end

    member do
      put :vote, votable_type: 'Question'
      delete :cancel_vote, votable_type: 'Question'
    end
  end

  resources :files, shallow: true, only: %i[] do
    delete :question_destroy
  end

  resources :answers, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Answer' }, only: %i[create destroy]
  end

  resources :questions, only: %i[] do
    resources :comments, shallow: true, defaults: { commentable_type: 'Question' }, only: %i[create destroy]
  end

  resources :achievements, only: %i[index]
  resources :links, only: %i[destroy]
end