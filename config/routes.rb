Enspiral::Application.routes.draw do

  get 'mockups/:action', :controller => 'mockups'
  scope :controller => 'pages' do
    get :about
    get :recruitment
    get :contact
    get :spotlight
    get :working_here
    get :social_media
    get :social_media_booking
    get :log_lead
    get :thank_you
  end
  root :to => 'pages#index'

  #members
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  # for the current person
  # personal_controller
  # personal/accounts controller
  #   still using /accounts views though
  get 'intranet' => 'intranet#index'

  scope path: :personal do
    resource :profile, only: [:edit, :update]
    resources :accounts, only: [:index, :show] do
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      resources :transactions
      resources :account_permissions, :as => 'permissions'
    end
    resources :funds_transfers

    resources :projects

    scope path: :capacity, controller: :project_bookings, as: :capacity do
      get '/', :action => :index
      get :edit
      put :update
    end

    resources :projects
    resources :project_memberships, :except => [:index, :edit, :show, :update]
    match '/project_memberships/update' => 'project_memberships#update', :via => :put, :as => :project_memberships_update
  end

  resources :companies do
    resources :accounts, only: [:index, :show] do
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      get '/transfer' => 'accounts#transfer', :as => :transfer
      post '/do_transfer' => 'accounts#do_transfer', :as => :do_transfer
      resources :account_permissions, :as => 'permissions'
    end
    resources :customers
    resources :projects
    resources :memberships
    resources :invoices
  end

  namespace :admin do
    get '/' => 'people#index'
    get '/dashboard' => 'dashboard#dashboard'
    get '/balances/:person_id/(:limit)' => 'people#balances', :as => :balances
    get '/enspiral_balances' => 'dashboard#enspiral_balances', :as => :enspiral_balances

    resources :companies, :only => [:new, :create, :destroy, :index]
    resources :accounts
    resources :transactions
    resources :projects, :only => [:index, :destroy]
    resources :funds_transfers
   
    get '/capacity' => 'project_bookings#index', :as => :capacity
    get '/capacity/person/:id' => 'project_bookings#person', :as => :person_capacity
    
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
  end

 
  #match 'services' => 'services#index', :as => :services
  #match 'services/search' => 'services#search', :as => :services_search
  #namespace :staff do
  #
    #get '/' => 'dashboard#dashboard'
    #get '/dashboard' => 'dashboard#dashboard'

    #match '/capacity' => 'project_bookings#index', :via => :get, :as => :capacity
    #match '/capacity/edit' => 'project_bookings#edit', :via => :get, :as => :capacity_edit
    #match '/capacity/update' => 'project_bookings#update', :via => :put, :as => :capacity_update

    #match 'funds_transfer' => 'people#funds_transfer', :as => :funds_transfer

    #resources :customers
    #resources :services
    #resources :projects
    #resources :project_memberships, :except => [:index, :edit, :show, :update]
    #match '/project_memberships/update' => 'project_memberships#update', :via => :put, :as => :project_memberships_update

    #resources :accounts do
      #get '/balances/(:limit)' => "accounts#balances", :as => :balances
      #get '/history' => 'accounts#history', :as => :history
      #get '/transfer' => 'accounts#transfer', :as => :transfer
      #post '/do_transfer' => 'accounts#do_transfer', :as => :do_transfer
      #resources :account_permissions, :as => 'permissions'
    #end

    #namespace :reports do
      #resources :sales, :controller => :sales_report, :only => :index
    #end
  #end

  #resources :people do
    #member do
      #post :check_gravatar_once
      #get :deactivate
      #get :activate
    #end
    #collection do
      #get :list
      #get :inactive
    #end
  #end
  
  resources :users
  #resources :teams do
    #member do
      #delete :remove_person
      #post :add_person
    #end
  #end

  
end
