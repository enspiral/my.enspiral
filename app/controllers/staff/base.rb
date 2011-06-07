class Staff::Base < ApplicationController
  before_filter :require_staff
  layout 'intranet'
end

