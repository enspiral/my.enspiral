class ProjectsController < IntranetController
  before_filter :load_project, only: [:show, :edit, :update, :destroy]

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
    @project = Project.find(params[:id])

    @project_bookings = ProjectBooking.get_projects_project_bookings(@project, params[:dates])

    @formatted_dates = ProjectBooking.get_formatted_dates(params[:dates])
    @current_weeks = ProjectBooking.sanatize_weeks(params[:dates])
    @next_weeks = ProjectBooking.next_weeks(@current_weeks)
    @previous_weeks = ProjectBooking.previous_weeks(@current_weeks)
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
  def load_project
    @project = Project.find(params[:id]) if params[:id]
  end
end
