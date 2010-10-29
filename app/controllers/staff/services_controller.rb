class Staff::ServicesController < Staff::Base
  # GET /staff/services
  # GET /staff/services.xml
  def index
    @services = current_person.services.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @services }
    end
  end

  # GET /staff/services/1
  # GET /staff/services/1.xml
  # def show
  #   @service = current_person.services.find(params[:id])
  # 
  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.xml  { render :xml => @service }
  #   end
  # end

  # GET /staff/services/new
  # GET /staff/services/new.xml
  def new
    @service = current_person.services.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service }
    end
  end

  # GET /staff/services/1/edit
  def edit
    @service = current_person.services.find(params[:id])
  end

  # POST /staff/services
  # POST /staff/services.xml
  def create
    @service = current_person.services.new(params[:service])

    respond_to do |format|
      if @service.save
        format.html { redirect_to(staff_services_url, :notice => 'Service was successfully created.') }
        format.xml  { render :xml => @service, :status => :created, :location => @service }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /staff/services/1
  # PUT /staff/services/1.xml
  def update
    @service = current_person.services.find(params[:id])

    respond_to do |format|
      if @service.update_attributes(params[:service])
        format.html { redirect_to(staff_services_url, :notice => 'Service was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /staff/services/1
  # DELETE /staff/services/1.xml
  def destroy
    @service = current_person.services.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to(staff_services_url) }
      format.xml  { head :ok }
    end
  end
end
