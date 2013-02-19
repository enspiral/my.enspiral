Enspiral::Application.routes.draw do
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout'}
  devise_scope :user do
    get "login",  :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  scope :controller => 'pages' do
    match :contact
    #get :about
    get :recruitment
    get :spotlight
    get :working_here
    get :social_media
    get :social_media_booking
    get :log_lead
    get :thank_you
  end
  root :to => 'marketing#index'


  namespace :marketing do
    resources :people, :only => [:index, :show]
    resources :companies, :only => [:index, :show]
    resources :projects, :only => [:index, :show]
    get :fetch_tweets, :as => :fetch_tweets
    get :load_social_items, :as => :load_social_items
    post '/contact', :as => :contact
  end

  get 'people/:id', :controller => 'marketing/people', :action => 'show'
  get 'people/', :controller => 'marketing/people', :action => 'index'
  get 'ventures/', :controller => 'marketing/companies', :action => 'index'
  get 'vision', :controller => 'marketing', :action => 'vision', :as => :marketing_vision
  get 'about', :controller => 'marketing', :action => 'about', :as => :marketing_about
  get 'space', :controller => 'marketing', :action => 'space', :as => :marketing_space
  get 'contact_us', :controller => 'marketing', :action => 'contact_us', :as => :marketing_contact_us
  get 'check_blog_fetches', :controller => 'intranet', action: 'check_blog_fetches', :as => :check_blog_fetches

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
  resources :funds_transfers

  resources :projects do
    get :edit_project_bookings
    put :update_project_bookings, on: :member
    resources :invoices do
      get :closed, on: :collection
      post :close, on: :member
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
    resources :invoices do
      get :closed, :on => :collection
      post :close, on: :member
      post :disburse, :on => :member
      post :pay_and_disburse, :on => :member
    end
  end

  resources :companies do
    resources :accounts do
      get 'public', on: :collection
      get 'expense', on: :collection
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
      resources :invoices do
        get :closed, :on => :collection
        post :disburse, :on => :member
        post :pay_and_disburse, :on => :member
      end
    end

    resources :projects do
      resources :invoices do
        get :closed, :on => :collection
        post :disburse, :on => :member
        post :pay_and_disburse, :on => :member
      end
    end

    resources :company_memberships, :path => :memberships do
      get :new_person, on: :collection
    end

    resources :invoices do
      collection do
        get :projects
        get :closed
      end
      post :close, on: :member
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
