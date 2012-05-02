class Admin::ServiceCategoriesController < AdminController
  def index
    @service_categories = ServiceCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @service_categories }
    end
  end

  def show
    @service_category = ServiceCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @service_category }
    end
  end

  def new
    @service_category = ServiceCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @service_category }
    end
  end

  def edit
    @service_category = ServiceCategory.find(params[:id])
  end

  def create
    @service_category = ServiceCategory.new(params[:service_category])

    respond_to do |format|
      if @service_category.save
        format.html { redirect_to(admin_service_categories_url, :notice => 'Service category was successfully created.') }
        format.xml  { render :xml => @service_category, :status => :created, :location => @service_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @service_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @service_category = ServiceCategory.find(params[:id])

    respond_to do |format|
      if @service_category.update_attributes(params[:service_category])
        format.html { redirect_to(admin_service_categories_url, :notice => 'Service category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @service_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @service_category = ServiceCategory.find(params[:id])
    @service_category.destroy

    respond_to do |format|
      format.html { redirect_to(admin_service_categories_url) }
      format.xml  { head :ok }
    end
  end
end
