class Admin::CitiesController < Admin::Base
  # GET /admin/cities
  # GET /admin/cities.xml
  def index
    @cities = City.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
  end

  # GET /admin/cities/new
  # GET /admin/cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /admin/cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /admin/cities
  # POST /admin/cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(admin_cities_url, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/cities/1
  # PUT /admin/cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(admin_cities_url, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/cities/1
  # DELETE /admin/cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(admin_cities_url) }
      format.xml  { head :ok }
    end
  end
end
