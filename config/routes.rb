Rails.application.routes.draw do
  resources :questions, only: %i[create show] do
    resources :answers, only: %i[create show]
  end
end
