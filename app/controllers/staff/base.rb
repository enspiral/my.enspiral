class Staff::Base < ApplicationController
  layout 'intranet'
  before_filter :require_staff
end

