class ProjectsController < IntranetController
  before_filter :load_project
  before_filter :detect_project_admin
  before_filter :require_project_or_company_admin, only: [:edit, :update, :destroy]
  before_filter :parse_date_range

  def new_customer
    @customer = Customer.new
  end

  def create_customer
    @customer = Customer.create(params[:customer])

    unless @customer.valid?
      render :new_customer
    end
  end

  def index
    if @company
      @all_projects = Project.where(:company_id => @company.id)
    else
      @current_projects = current_person.projects
      @all_projects = Project.where(:company_id => current_person.company_ids)
    end
  end

  def show
  end

  def new
    @project = Project.new
    @project.project_memberships.build(person: current_person, is_lead: true)
  end

  def create
    @project = Project.new(params[:project])
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
    redirect_to [@company, Project]
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
    @project = Project.find(params[:id]) if params[:id]
  end

  def parse_date_range
    @start_on = params[:start_on] || Date.today.at_beginning_of_week
    @finish_on = params[:finish_on] || @start_on + 8.weeks
  end
end
