Enspiral::Application.routes.draw do
  root :to => 'pages#index'
  
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout'}

  devise_scope :user do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  match '/about' => 'pages#about', :as => :about
  match '/recruitment' => 'pages#recruitment', :as => :recruitment
  match '/contact' => 'pages#contact', :as => :contact
  match '/social_media_booking' => 'pages#social_media_booking', :as => :social_media_booking
  match '/social_media' => 'pages#social_media', :as => :social_media
  match '/log_lead' => 'people#log_lead', :as => :log_lead
  match '/thank_you' => 'people#thank_you', :as => :thank_you
 
  match 'services' => 'services#index', :as => :services
  match 'services/search' => 'services#search', :as => :services_search
  
  namespace :admin do
    get '/' => 'people#index'
    get '/dashboard' => 'dashboard#dashboard'
    
    resources :accounts
    resources :transactions

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
    resources :cities
    resources :customers
  end

  namespace :staff do
    get '/' => 'dashboard#dashboard'
    get '/dashboard' => 'dashboard#dashboard'
    get '/history' => 'dashboard#history'

    match 'funds_transfer' => 'people#funds_transfer', :as => :funds_transfer
    resources :services

    namespace :reports do
      resources :sales, :controller => :sales_report, :only => :index
    end
  end

  resources :people do
    member do
      post :check_gravatar_once
      get :deactivate
      get :activate
    end
    collection do
      get :inactive
    end
  end
  
  resources :users
  resources :teams do
    member do
      delete :remove_person
      post :add_person
    end
  end

  resources :projects
  resources :accounts
  resources :badges
  resources :badge_ownerships
  
  resources :notices do
    resources :comments
  end
  
  resources :comments do
    resources :comments
  end
  
  match '/:controller(/:action(/:id))'
end
