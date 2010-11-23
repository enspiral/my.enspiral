class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #layout 'default'

  before_filter :get_contacts

  private
 
  def get_contacts
    @contacts ||= Person.contacts
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.record
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
