Mousetrap::Application.routes.draw do
  devise_for :users
  
  # 1. resources :users, :only => [:index]
  
  resources :users, :only => [:index] do
    resource :profile
  end

  
  root :to => 'home#index'

end
