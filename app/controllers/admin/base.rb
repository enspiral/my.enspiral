class Admin::Base < ApplicationController
#  before_filter :login_required
#  before_filter :admin_only
  
  layout "admin"
  
  private
  
#    def admin_only
#      unless current_user.admin?
#        redirect_to '/'
#      end
#    end
end

