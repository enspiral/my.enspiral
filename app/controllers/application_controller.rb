class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method [:current_user, :admin_user?, :current_person]
  before_filter :get_contacts

  if Rails.env == 'production'
    analytical :modules=>[:google, :kiss_metrics], :use_session_store=>true
  else
    analytical :modules=>[:console], :use_session_store=>true
  end 

  private


  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when User 
      (resource_or_scope.admin? ? accounts_url(current_person) : accounts_url(current_person))
    when :user
      root_url
    else
      super
    end
  end

  def get_contacts
    @contacts ||= Person.contacts
  end

  def current_person
    current_user.nil? ? nil : current_user.person
  end

  def require_staff
    authenticate_user!
  end

  def require_admin
    authenticate_user!
    redirect_to root_url, :alert => "You do not have permission to access this page." unless admin_user?
  end

  def require_no_user
    if user_signed_in?
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def admin_user?
    res = current_user && current_user.admin?
  end
end
