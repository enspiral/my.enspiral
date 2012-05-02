class AdminController < IntranetController
  before_filter :require_admin
  before_filter :admin_load_objects
end

