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
    resources :people, :only => [:index, :show], :as => "enspiral_company_net_people"
    resources :companies, :only => [:index, :show], :as => "enspiral_company_net_companies"
    resources :projects, :only => [:index, :show], :as => "enspiral_company_net_projects"
    get :fetch_tweets, :as => :fetch_tweets
    get :load_social_items, :as => :load_social_items
    post '/contact', :as => :contact
  end

  get 'people/:id', :controller => 'marketing/people', :action => 'show'
  get 'people/', :controller => 'marketing/people', :action => 'index'
  get '/about', :controller => 'marketing', :action => 'about', :as => :marketing_about
  get '/contact_us', :controller => 'marketing', :action => 'contact_us', :as => :marketing_contact_us
  get 'check_blog_fetches', :controller => 'intranet', action: 'check_blog_fetches', :as => :check_blog_fetches

  get 'roladex' => 'profiles#roladex'
  get 'search' => 'search#index'
  match 'people/get_cities/:id' => 'people#get_cities'

  resources :profiles, only: [:edit, :update, :show, :index, :check_blog_fetches] do 
  end

  resources :accounts, :as => "enspiral_money_tree_accounts" do
    get 'public', on: :collection
    get '/balances/(:limit)' => "enspiral_money_tree_accounts#balances", :as => :balances
    get 'transactions', on: :member
    resources :accounts_people
    resources :accounts_companies
  end
  resources :funds_transfers, :as => "enspiral_money_tree_funds_transfers"

  resources :projects, :as => "enspiral_company_net_projects" do
    get :edit_project_bookings
    put :update_project_bookings, on: :member
    resources :invoices, :as => "enspiral_money_tree_invoices" do
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

  resources :customers, :as => "enspiral_company_net_customers" do
    resources :invoices, :as => "enspiral_money_tree_invoices" do
      get :closed, :on => :collection
      post :close, on: :member
      post :disburse, :on => :member
      post :pay_and_disburse, :on => :member
    end
  end

  resources :companies, :as => 'enspiral_company_net_companies' do
    resources :accounts, :as => "enspiral_money_tree_accounts" do
      get 'public', on: :collection
      get 'expense', on: :collection
      get '/balances/(:limit)' => "accounts#balances", :as => :balances
      get '/history' => 'accounts#history', :as => :history
      get '/transfer' => 'accounts#transfer', :as => :transfer
      post '/do_transfer' => 'accounts#do_transfer', :as => :do_transfer
      get 'transactions', on: :member
      resources :accounts_people
      resources :accounts_companies
    end

    resources :funds_transfers, :as => "enspiral_money_tree_funds_transfers"
    resources :funds_transfer_templates, :as => "enspiral_money_tree_funds_transfer_templates" do
      post :generate, on: :member
    end

    resources :customers, :as => "enspiral_company_net_customers" do
      resources :invoices, :as => "enspiral_money_tree_invoices" do
        get :closed, :on => :collection
        post :disburse, :on => :member
        post :pay_and_disburse, :on => :member
      end
    end

    resources :projects, :as => "enspiral_company_net_projects" do
      resources :invoices, :as => "enspiral_money_tree_invoices" do
        get :closed, :on => :collection
        post :disburse, :on => :member
        post :pay_and_disburse, :on => :member
      end
    end

    resources :company_memberships, :path => :memberships do
      get :new_person, on: :collection
    end

    resources :invoices, :as => "enspiral_money_tree_invoices" do
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
    resources :companies, :as => 'enspiral_company_net_companies' do
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
end
