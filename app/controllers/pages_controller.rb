class PagesController < ApplicationController
  
  def holding
    render :action => 'holding', :layout => 'holding'
  end

  def index
  end

  def services
  end
  
  def contact
    @phone_number = '04 123 1234'
  end
  
end
