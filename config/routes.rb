Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Devise configuration
  root to: "home#index"
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }

  mount ActionCable.server => '/cable'

  post 'api/auth', to: 'api#auth', as: :auth

  namespace :api do
    # Users
    get 'users/me', to: 'users#me', as: :user_data
    get 'users/:user_id', to: 'users#show'
    get 'users', to: 'users#index'
    get 'users/:user_id/rooms', to: 'rooms#rooms_by_user', as: :user_rooms

    # Rooms
    get 'rooms', to: 'rooms#index'
    get 'rooms/:room_id', to: 'rooms#show'
    get 'rooms/:room_id/messages', to: 'messages#messages_by_room'

    # Messages
    post 'messages/create', to: 'messages#create'
  end
end
