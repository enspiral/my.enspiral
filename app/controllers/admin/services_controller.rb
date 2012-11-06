class Admin::ServicesController < ApplicationController
  # GET /admin/services
  # GET /admin/services.json
  def index
    @admin_services = Admin::Service.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_services }
    end
  end

  # GET /admin/services/1
  # GET /admin/services/1.json
  def show
    @admin_service = Admin::Service.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_service }
    end
  end

  # GET /admin/services/new
  # GET /admin/services/new.json
  def new
    @admin_service = Admin::Service.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @admin_service }
    end
  end

  # GET /admin/services/1/edit
  def edit
    @admin_service = Admin::Service.find(params[:id])
  end

  # POST /admin/services
  # POST /admin/services.json
  def create
    @admin_service = Admin::Service.new(params[:admin_service])

    respond_to do |format|
      if @admin_service.save
        format.html { redirect_to @admin_service, notice: 'Service was successfully created.' }
        format.json { render json: @admin_service, status: :created, location: @admin_service }
      else
        format.html { render action: "new" }
        format.json { render json: @admin_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/services/1
  # PUT /admin/services/1.json
  def update
    @admin_service = Admin::Service.find(params[:id])

    respond_to do |format|
      if @admin_service.update_attributes(params[:admin_service])
        format.html { redirect_to @admin_service, notice: 'Service was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @admin_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/services/1
  # DELETE /admin/services/1.json
  def destroy
    @admin_service = Admin::Service.find(params[:id])
    @admin_service.destroy

    respond_to do |format|
      format.html { redirect_to admin_services_url }
      format.json { head :no_content }
    end
  end
end
