class Staff::ProjectPeopleController < Staff::Base
  # GET /staff/project_people
  # GET /staff/project_people.json
  def index
    @project_people = ProjectPerson.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_people }
    end
  end

  # GET /staff/project_people/1
  # GET /staff/project_people/1.json
  def show
    @project_person = ProjectPerson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_person }
    end
  end

  # GET /staff/project_people/new
  # GET /staff/project_people/new.json
  def new
    @project_person = ProjectPerson.new
    @project_person.project_id = params[:id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_person }
    end
  end

  # GET /staff/project_people/1/edit
  def edit
    @project_person = ProjectPerson.find(params[:id])
  end

  # POST /staff/project_people
  # POST /staff/project_people.json
  def create
    @project_person
    if (params[:project_id])
      @project_person = ProjectPerson.find_or_create_by_person_id_and_project_id(:project_id => params[:project_id], :person_id => current_person.id)
    else
      @project_person = ProjectPerson.create(params[:project_person])
    end

    respond_to do |format|
      if @project_person.save
        format.html { redirect_to staff_projects_path, notice: 'Project membership was successfully created.' }
        format.json { render json: @project_person, status: :created, location: @project_person }
      else
        format.html { render action: "new" }
        format.json { render json: @project_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /staff/project_people/1
  # PUT /staff/project_people/1.json
  def update
    @project_person = ProjectPerson.find(params[:id])

    respond_to do |format|
      if @project_person.update_attributes(params[:project_person])
        format.html { redirect_to staff_project_person_path(@project_person), notice: 'Project person was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff/project_people/1
  # DELETE /staff/project_people/1.json
  def destroy
    @project_person
    if params[:project_id]
      @project_person = ProjectPerson.find_by_project_id_and_person_id(params[:project_id], current_person.id) 
    else
      @project_person = ProjectPerson.find(params[:id])
    end
    @project_person.destroy

    respond_to do |format|
      format.html { redirect_to staff_projects_path }
      format.json { head :ok }
    end
  end
end
