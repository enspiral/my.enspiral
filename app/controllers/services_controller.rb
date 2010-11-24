class ServicesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @services = Service.order('rate desc')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end
  
  def search
    service_category_id = params[:service_category_id].to_s.strip
    description = params[:description].to_s.strip
    
    @services = Service.search :service_category_id => service_category_id, :description => description
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @services }
      format.js   { render :partial => 'list' }
    end
  end
  
end
