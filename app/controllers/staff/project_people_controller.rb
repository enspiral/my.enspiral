class Staff::ProjectPeopleController < ApplicationController
  # GET /staff/project_people
  # GET /staff/project_people.json
  def index
    @project_people = ProjectPerson.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @staff_project_people }
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
    @project_person = ProjectPerson.new(params[:project_person])

    respond_to do |format|
      if @project_person.save
        format.html { redirect_to staff_project_person_path(@project_person), notice: 'Project person was successfully created.' }
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
    @project_person = ProjectPerson.find(params[:id])
    @project_person.destroy

    respond_to do |format|
      format.html { redirect_to staff_project_people_url }
      format.json { head :ok }
    end
  end
end
