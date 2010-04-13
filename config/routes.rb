ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'holding'
  map.contact '/contact', :controller => 'pages', :action => 'contact'

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions

  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.dashboard 'dashboard/:action', :controller => 'dashboard'
    admin.resources :accounts
    admin.resources :people
    admin.resources :invoices
    admin.resources :invoice_allocations
  end

  map.namespace :staff do |staff|
    staff.root :controller => 'dashboard', :action => 'index'
    staff.dashboard 'dashboard/:action', :controller => 'dashboard'
  end

  map.resources :people
  map.resources :teams, :member => {:remove_person => :any, :add_person => :post}
  map.resources :projects, :member => {:remove_person => :any, :add_person => :post}
  map.resources :services
  map.resources :accounts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
