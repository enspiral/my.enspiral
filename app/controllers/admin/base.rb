class Admin::Base < ApplicationController
  layout 'intranet'
  before_filter :require_admin
end

