class Admin::Base < ApplicationController
  before_filter :require_admin
  layout 'application'
end

