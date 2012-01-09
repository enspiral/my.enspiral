class Staff::ProjectMembershipsController < Staff::Base

  # GET /staff/project_memberships/new
  # GET /staff/project_memberships/new.json
  def new
    @project_membership = ProjectMembership.new
    @project = Project.find(params[:project_id])
    @project_membership.project = @project

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_membership }
    end
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
    @project = Project.find(params[:project_id])
    @project.project_memberships.each { |t| t.attributes = params[:project_membership][t.id.to_s] }
    
    respond_to do |format|
      if @project.project_memberships.all?(&:valid?)
        @project.project_memberships.each(&:save!)
        format.html { redirect_to staff_project_path(@project), notice: 'Project Membership was successfully updated.' }
        format.json { head :ok }
      else
        flash[:notice] = 'There was an error when updating the project memberships'
        format.html { render 'staff/projects/edit' }
        format.json { render json: @project.project_membership.errors, status: :unprocessable_entity }
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
