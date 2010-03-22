ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'holding'
  map.contact '/contact', :controller => 'pages', :action => 'contact'

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions

  map.namespace :admin do |admin|
    admin.dashboard 'dashboard', :controller => 'dashboard', :action => 'index'
    admin.resources :accounts
    admin.resources :people
  end

  map.resources :users
  map.resources :people, :member => {:dashboard => :get}
  map.resources :teams, :member => {:remove_person => :any, :add_person => :post}
  map.resources :projects, :member => {:remove_person => :any, :add_person => :post}
  map.resources :services
  map.resources :accounts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
