Mousetrap::Application.routes.draw do
  devise_for :users
  
  # 1. resources :users, :only => [:index]
  
  resources :users, :only => [:index] do
    resource :profile, :except => [:destroy] do
      resources :comments
    end
  end

  
  root :to => 'home#index'

end
