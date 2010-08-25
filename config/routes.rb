ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'holding'
  map.about '/about', :controller => 'pages', :action => 'about'
  map.recruitment '/recruitment', :controller => 'pages', :action => 'recruitment'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  map.social_media_booking '/social_media_booking', :controller => 'pages', :action => 'social_media_booking'
  map.social_media '/social_media', :controller => 'pages', :action => 'social_media'
  map.rails '/rails', :controller => 'pages', :action => 'rails'
  map.rails_confirmation '/thank_you', :controller => 'pages', :action => 'rails_confirmation'

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.resources :user_sessions
  map.resources :passwords

  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.dashboard 'dashboard/:action', :controller => 'dashboard'
    admin.resources :accounts
    admin.resources :people, :member => {'new_transaction' => :get, 'create_transaction' => :post}
    admin.resources :invoices, :collection => {'old' => :get}, :member => {'pay' => :get}
    admin.resources :invoice_allocations
  end

  map.namespace :staff do |staff|
    staff.root :controller => 'dashboard', :action => 'index'
    staff.dashboard 'dashboard/:action', :controller => 'dashboard'
  end

  map.resources :people
  map.resources :users, :controller => "people"
  map.resources :teams, :member => {:remove_person => :any, :add_person => :post}
  map.resources :projects, :member => {:remove_person => :any, :add_person => :post}
  map.resources :services
  map.resources :accounts

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
