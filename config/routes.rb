Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Devise configuration
  root to: "home#index"
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }

  post 'api/auth', to: 'api#auth', as: :auth

  namespace :api do
    get 'users/me', to: 'users#me', as: :user_data
    get 'users/:id', to: 'users#show'
    get 'users', to: 'users#index'
    get 'users/:user_id/rooms', to: 'rooms#rooms_by_user', as: :user_rooms
  end
end
