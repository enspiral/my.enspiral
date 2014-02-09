Enspiral::Application.routes.draw do
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root :to => 'accounts#index'

  get 'roladex' => 'profiles#roladex'
  get 'search' => 'search#index'
  match 'people/get_cities/:id' => 'people#get_cities'

  resources :profiles, only: [:edit, :update, :show, :index, :check_blog_fetches] do 
  end

  resources :accounts do
    get 'public', on: :collection
    get '/balances/(:limit)' => "accounts#balances", :as => :balances
    get 'transactions', on: :member
    resources :accounts_people
    resources :accounts_companies
  end

  resources :projects do
    get :edit_project_bookings
    put :update_project_bookings, on: :member
    resources :invoices do
      get :closed, on: :collection
      post :close, on: :member
      post :approve, on: :member
      post :reverse, on: :member
      get :search, on: :collection
      get :imported, on: :collection
    end
  end

  get '/capacity' => 'project_bookings#index', :as => :capacity
  get '/capacity/person/:id' => 'project_bookings#person', :as => :person_capacity

  resources :your_capacity, only: :index do
    put :update, on: :collection
  end

  resources :project_memberships, :except => [:index, :edit, :show, :update] do
    put :update, on: :collection
  end

  resources :customers do
    post :approve, on: :member
    resources :invoices do
      get :closed, :on => :collection
      post :close, on: :member
      post :approve, on: :member
      post :reverse, on: :member
      post :disburse, :on => :member
      post :pay_and_disburse, :on => :member
      get :imported, on: :collection
      get :search, on: :collection
    end
  end

  resources :companies do
    resources :accounts do
      get 'public', on: :collection
      get 'external', on: :collection
      match 'historic_balances', on: :collection
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      get '/transfer' => 'accounts#transfer', :as => :transfer
      post '/do_transfer' => 'accounts#do_transfer', :as => :do_transfer
      get 'transactions', on: :member
      resources :accounts_people
      resources :accounts_companies
    end

    resources :funds_transfers
    resources :funds_transfer_templates do
      post :generate, on: :member
    end

    resources :customers do
      post :approve, on: :member
      get  :pending, :on => :collection
      resources :invoices do
        get :closed, :on => :collection
        get :imported, :on => :collection
        post :disburse, :on => :member
        post :reverse, :on => :member
        post :pay_and_disburse, :on => :member
        get :search, :on => :collection
      end
    end

    resources :projects do
      resources :invoices do
        get :closed, :on => :collection
        get :imported, :on => :collection
        post :disburse, :on => :member
        post :reverse, :on => :member
        post :pay_and_disburse, :on => :member
        get :search, :on => :collection
      end
    end

    resources :company_memberships, :path => :memberships do
      get :new_person, on: :collection
    end

    resources :invoices do
      collection do
        get :projects
        get :closed
        get :search
        get :imported
      end
      post :close, on: :member
      post :approve, on: :member
      post :reverse, on: :member
    end

    resources :metrics
  end

  namespace :admin do
    resources :featured_items
    resources :companies do
      resources :company_memberships do
        get :new_person, on: :collection
      end
    end

    resources :groups
    resources :skills
    resources :service_categories
    resources :countries
    resources :cities


  end

  match 'surveys' => 'surveys#index', as: :surveys
  match 'upload_survey' => 'surveys#upload_survey', as: :upload_surveys
  post '/upload_survey' => 'surveys#upload_survey', :as => :upload_surveys
  match 'survey_results/(:id)' => 'surveys#survey_results', as: :survey_results
  match 'take_survey' => 'surveys#survey', as: :take_survey
  match '/midtranet' => 'midtranet#index', as: :midtranet

 
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
end
