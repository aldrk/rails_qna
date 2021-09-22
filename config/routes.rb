Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  root to: 'questions#index'

  resources :questions, only: %i[new create show destroy update] do
    resources :answers, shallow: true, only: %i[create show destroy update] do
      member do
        patch :nominate
      end
    end
  end
end