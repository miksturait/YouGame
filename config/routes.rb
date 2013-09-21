YouGame::Application.routes.draw do

  mount Resque::Server.new, at: "/resque" #if Rails.env.development?

  match '/users/sign_in' => 'home#index', via: :get

  devise_for :users

  resources :home, only: :index
  namespace :my, only: :show do
    resource :screen
    resource :tracker, only: [:new, :create, :show]
    resources :reports, only: [:new, :create]
    root to: 'screen#show'
  end
  namespace :admin do
    resource :setting, only: [:show, :update, :create]
    resources :custom_achievements, except: [:destroy] do
      member do
        post :grant
      end
    end
    root to: 'setting#show'
  end
  namespace :api do
    resources :points, only: :create
  end

  authenticated :user do
    root to: "my/screens#show"
  end

  root to: 'home#index'

end
