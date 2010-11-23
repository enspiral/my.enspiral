class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #layout 'default'

  helper_method [:current_user, :admin_user?, :current_person]
  before_filter :get_contacts

  private

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when User 
      (resource_or_scope.admin? ? admin_url : staff_url)
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

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_staff
    if !current_user
      return require_user
    elsif !current_user.staff? && !current_user.admin?
      flash[:notice] = "You do not have permission to access this page"
      redirect_to :back
    end
  end

  def require_admin
    if !current_user
      return require_user
    elsif !current_user.admin?
      flash[:notice] = "You do not have permission to access this page"
      redirect_to :back
    end
  end

  def require_no_user
    if current_user
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
    current_user && current_user.admin?
  end
end
