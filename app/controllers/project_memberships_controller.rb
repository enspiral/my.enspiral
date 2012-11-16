class ProjectMembershipsController < IntranetController
  before_filter :load_project

  def create
    @project.project_memberships.create!(person: current_person)
    redirect_to @project
  end

  def destroy
    @project_membership
    if params[:project_id]
      @project_membership = ProjectMembership.find_by_project_id_and_person_id(params[:project_id], current_person.id) 
    else
      @project_membership = ProjectMembership.find(params[:id])
    end
    @project_membership.destroy

    respond_to do |format|
      format.html { redirect_to enspiral_company_net_projects_path }
      format.json { head :ok }
    end
  end

  private
  def load_project
    if params[:project_id]
      @project = Enspiral::CompanyNet::Project.find params[:project_id]
    end
  end
end
