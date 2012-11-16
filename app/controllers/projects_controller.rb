class ProjectsController < IntranetController
  before_filter :load_project
  before_filter :detect_project_admin
  before_filter :require_project_or_company_admin, only: [:edit, :update, :destroy, :edit_project_bookings, :update_project_bookings]
  before_filter :parse_date_range

  def index
    if @company
      @all_projects = Enspiral::CompanyNet::Project.where(:company_id => @company.id)
    else
      @current_projects = current_person.projects.active
      @all_projects = Enspiral::CompanyNet::Project.where(:company_id => current_person.company_ids)
    end
  end

  def show
  end

  def edit_project_bookings
  end

  def update_project_bookings
    for pb_params in params[:project_bookings]
      pb = @project.project_bookings.
            find_or_create_by_project_membership_id_and_week(
              pb_params[:project_membership_id], pb_params[:week])
      pb.update_attribute(:time, pb_params[:time])
    end
    redirect_to @project, notice: 'Capacity details updated'
  end

  def new
    @project = Enspiral::CompanyNet::Project.new
    @project.project_memberships.build(person: current_person, is_lead: true)
  end

  def create
    @project = Enspiral::CompanyNet::Project.new(params[:project])
    if @project.save
      redirect_to [@company, @project],
                  notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to [@company, @project],
                  notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to [@company, Enspiral::CompanyNet::Project]
  end

  protected
  def detect_project_admin
    if @project
      if current_person.admin_companies.include? @project.company or @project.leads.include? current_person
        @project_admin = true
      end
    end
  end

  def require_project_or_company_admin
    unless @project_admin
      flash[:notice] = 'You need to be a company admin or project lead to do that'
      redirect_to @project
    end
  end

  def load_project
    @project = Enspiral::CompanyNet::Project.find(params[:id]) if params[:id]
  end

end
