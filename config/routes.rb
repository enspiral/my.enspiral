Enspiral::Application.routes.draw do

  match '/contact' => 'pages#contact', as: :contact
  scope :controller => 'pages' do
    get :about
    get :recruitment
    get :spotlight
    get :working_here
    get :social_media
    get :social_media_booking
    get :log_lead
    get :thank_you
  end

  get 'mockups/:action', :controller => 'mockups'
  root :to => 'pages#index'

  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  get 'intranet' => 'intranet#index'

  scope path: :personal do
    resource :profile, only: [:edit, :update]
    match '/capacity' => 'project_bookings#index', :via => :get, :as => :capacity
    resources :accounts do
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      resources :transactions
      resources :accounts_people
      resources :accounts_companies
    end
    resources :funds_transfers

    resources :projects

    scope path: :capacity, controller: :project_bookings, as: :capacity do
      get '/', :action => :index
      get :edit
      put :update
    end

    resources :project_memberships, :except => [:index, :edit, :show, :update]
    match '/project_memberships/update' => 'project_memberships#update', :via => :put, :as => :project_memberships_update
  end

  resources :companies, only: [] do

    resources :accounts do
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      get '/transfer' => 'accounts#transfer', :as => :transfer
      post '/do_transfer' => 'accounts#do_transfer', :as => :do_transfer
      resources :accounts_people
      resources :accounts_companies
    end

    resources :funds_transfers
    resources :customers
    resources :projects

    resources :company_memberships, :path => :memberships do
      collection do
        get :new_person
      end
    end

    resources :invoices do
      get :old, :on => :collection
      post :pay, :on => :member
      resources :payments, only: [:create, :show]
    end
    resources :invoice_allocations
  end

  namespace :admin do
    get '/' => 'people#index'
    get '/dashboard' => 'dashboard#dashboard'
    get '/balances/:person_id/(:limit)' => 'people#balances', :as => :balances
    get '/enspiral_balances' => 'dashboard#enspiral_balances', :as => :enspiral_balances

    resources :companies, :only => [:new, :create, :destroy, :index]
    resources :projects, :only => [:index, :destroy]

    get '/capacity' => 'project_bookings#index', :as => :capacity
    get '/capacity/person/:id' => 'project_bookings#person', :as => :person_capacity

    resources :service_categories
    resources :countries
    resources :cities
  end

  match '/roladex' => 'profiles#roladex', :as => :roladex
  match 'people/get_cities/:id' => 'people#get_cities'

 
  #match 'services' => 'services#index', :as => :services
  #match 'services/search' => 'services#search', :as => :services_search
  #namespace :staff do
  #
    #get '/' => 'dashboard#dashboard'
    #get '/dashboard' => 'dashboard#dashboard'

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
  resources :users
end
