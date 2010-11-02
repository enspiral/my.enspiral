class PasswordsController < ApplicationController
  before_filter :require_user
  
  def new
  end
  
  def create
    user = current_user
    
    if user.valid_password? params[:current_password]
      if params[:user].blank? || params[:user][:password].blank?
        flash[:error] = "Password can't be blank"
      elsif user.update_attributes params[:user]
        flash[:notice] = 'Password has been updated'
        if user.admin?
          redirect_to admin_dashboard_url
        else
          redirect_to staff_dashboard_url
        end
        return
      else
        flash[:error] = user.errors.full_messages.first
      end
    else
      flash[:error] = 'Password incorrect'
    end
    
    render :action => 'new'
  end
  
end
