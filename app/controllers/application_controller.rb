class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include SavageBeast::AuthenticationSystem
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  #layout 'default'

  helper_method [:current_user, :admin_user?, :current_person]

private
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
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def admin_user?
    current_user && current_user.admin?
  end

  # BEGIN Required for savage-beast
  def login_required
    if !current_user
			redirect_to root_url
      return false
		end
  end

  def authorized?()
    unless admin_user?
      redirect_to root_url
    end
  end

  def logged_in?
    current_user ? true : false
  end

  def admin?
    admin_user?
  end
  # END Required for savage-beast
end
