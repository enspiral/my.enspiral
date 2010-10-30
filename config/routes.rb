Enspiral::Application.routes.draw do
  root :to => 'pages#index'
  match '/about' => 'pages#about', :as => :about
  match '/recruitment' => 'pages#recruitment', :as => :recruitment
  match '/contact' => 'pages#contact', :as => :contact
  match '/social_media_booking' => 'pages#social_media_booking', :as => :social_media_booking
  match '/social_media' => 'pages#social_media', :as => :social_media
 
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  resources :user_sessions
  resources :passwords
  
  namespace :admin do
    match '/' => 'dashboard#index'
    match 'dashboard/:action' => 'dashboard#index', :as => :dashboard
    resources :accounts
    resources :people do
      member do
        get :new_transaction
        post :create_transaction
      end
    end
    resources :invoices do
      get :old, :on => :collection
      get :pay, :on => :member
    end
    resources :invoice_allocations
    resources :service_categories
    resources :countries
  end

  namespace :staff do
    match '/' => 'dashboard#index'
    match 'dashboard/:action' => 'dashboard#index', :as => :dashboard
  end

  resources :people do
    member do
      post :check_gravatar_once
    end
  end
  
  resources :users
  resources :teams do
    member do
      delete :remove_person
      post :add_person
    end
  end

  resources :projects do
    member do
      delete :remove_person
      post :add_person
    end
  end

  resources :services
  resources :accounts
  
  resources :notices do
    resources :comments
  end
  
  resources :comments do
    resources :comments
  end
  
  match '/:controller(/:action(/:id))'
end
