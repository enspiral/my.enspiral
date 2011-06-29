class NoticesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /notices
  # GET /notices.xml
  def index
    @notices = Notice.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notices }
    end
  end

  # GET /notices/1
  # GET /notices/1.xml
  def show
    @notice = Notice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notice }
    end
  end

  # GET /notices/new
  # GET /notices/new.xml
  def new
    @notice = current_person.notices.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notice }
    end
  end

  # GET /notices/1/edit
  # def edit
  #   @notice = Notice.find(params[:id])
  # end

  # POST /notices
  # POST /notices.xml
  def create
    @notice = current_person.notices.new(params[:notice])

    respond_to do |format|
      if @notice.save
        format.html { redirect_to(@notice, :notice => 'Notice was successfully created.') }
        format.xml  { render :xml => @notice, :status => :created, :location => @notice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notices/1
  # PUT /notices/1.xml
  # def update
  #   @notice = Notice.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @notice.update_attributes(params[:notice])
  #       format.html { redirect_to(@notice, :notice => 'Notice was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /notices/1
  # DELETE /notices/1.xml
  # def destroy
  #   @notice = Notice.find(params[:id])
  #   @notice.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(notices_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
end
