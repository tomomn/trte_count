Rails.application.routes.draw do
  root 'counts#index'
  resources :counts, only: [:index, :create]
end
