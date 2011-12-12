class Staff::ProjectMembershipsController < Staff::Base
  # GET /staff/project_memberships
  # GET /staff/project_memberships.json
  def index
    @project_memberships = ProjectMembership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_memberships }
    end
  end

  # GET /staff/project_memberships/1
  # GET /staff/project_memberships/1.json
  def show
    @project_membership = ProjectMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_membership }
    end
  end

  # GET /staff/project_memberships/new
  # GET /staff/project_memberships/new.json
  def new
    @project_membership = ProjectMembership.new
    @project_membership.project_id = params[:id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_membership }
    end
  end

  # GET /staff/project_memberships/1/edit
  def edit
    @project_membership = ProjectMembership.find(params[:id])
  end

  # POST /staff/project_memberships
  # POST /staff/project_memberships.json
  def create
    @project_membership
    if (params[:project_id])
      @project_membership = ProjectMembership.find_or_create_by_person_id_and_project_id(:project_id => params[:project_id], :person_id => current_person.id)
    else
      @project_membership = ProjectMembership.create(params[:project_membership])
    end

    respond_to do |format|
      if @project_membership.save
        format.html { redirect_to staff_projects_path, notice: 'Project Membership was successfully created.' }
        format.json { render json: @project_membership, status: :created, location: @project_membership }
      else
        format.html { render action: "new" }
        format.json { render json: @project_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /staff/project_memberships/1
  # PUT /staff/project_memberships/1.json
  def update
    @project_membership = ProjectMembership.find(params[:id])

    respond_to do |format|
      if @project_membership.update_attributes(params[:project_membership])
        format.html { redirect_to staff_project_membership_path(@project_membership), notice: 'Project Membership was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff/project_memberships/1
  # DELETE /staff/project_memberships/1.json
  def destroy
    @project_membership
    if params[:project_id]
      @project_membership = ProjectMembership.find_by_project_id_and_person_id(params[:project_id], current_person.id) 
    else
      @project_membership = ProjectMembership.find(params[:id])
    end
    @project_membership.destroy

    respond_to do |format|
      format.html { redirect_to staff_projects_path }
      format.json { head :ok }
    end
  end
end
