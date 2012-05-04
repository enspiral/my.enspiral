class ProjectsController < IntranetController

  helper_method :sort_column, :sort_direction

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
    @current_projects = current_person.projects
    if @company
      @all_projects = Project.where(:company_id => @company.id)
    else
      @all_projects = Project.where(:company_id => current_person.company_ids)
    end
    @all_projects = @all_projects.order("#{sort_column} #{sort_direction}")
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
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        @project_membership = ProjectMembership.create(:project_id => @project.id, :person_id => current_person.id, :is_lead => true)
        if @project_membership.save
          format.html { redirect_to(project_path(@project), notice: 'Project was successfully created.') }
          format.json { render json: @project, status: :created, location: @project }
        else
          format.html { render action: "new" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to project_path(@project), notice: 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end

  private
  
  def sort_column
    valid_columns = Project.column_names
    valid_columns << 'customers.name'
    if valid_columns.include? params[:sort]
      params[:sort]
    else
      'name'
    end
  end
  
  def sort_direction
    if params[:direction] == 'desc'
      'desc'
    else
      'asc'
    end
  end
end
