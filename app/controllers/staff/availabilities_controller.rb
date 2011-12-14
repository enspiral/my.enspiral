class Staff::AvailabilitiesController < Staff::Base
  # GET /availabilities
  # GET /availabilities.json
  def index
    offset = 0
    @projects = current_person.projects
    @availabilities = @template.find_or_create_availabilities_batch(offset, current_person, 'availability')

    @total_project_bookings = current_person.availabilities.filter_projects.get_offset_batch(offset).total_hours

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @availabilities }
    end
  end

  # GET /availabilities/1
  # GET /availabilities/1.json
  def show
    @availability = Availability.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @availability }
    end
  end

  # GET /availabilities/new
  # GET /availabilities/new.json
  def new
    @availability = Availability.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @availability }
    end
  end

  # GET /availabilities/1/edit
  def edit
    @availability = Availability.find(params[:id])
  end

  # POST /availabilities
  # POST /availabilities.json
  def create
    @availability = Availability.new(params[:availability])

    respond_to do |format|
      if @availability.save
        format.html { redirect_to staff_availability_path(@availability), notice: 'Availability was successfully created.' }
        format.json { render json: @availability, status: :created, location: @availability }
      else
        format.html { render action: "new" }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /availabilities/1
  # PUT /availabilities/1.json
  def update
    @availability = Availability.find(params[:id])

    respond_to do |format|
      if @availability.update_attributes(params[:availability])
        format.html { redirect_to staff_availability_path(@availability), notice: 'Availability was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @availability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /availabilities/1
  # DELETE /availabilities/1.json
  def destroy
    @availability = Availability.find(params[:id])
    @availability.destroy

    respond_to do |format|
      format.html { redirect_to staff_availabilities_url }
      format.json { head :ok }
    end
  end

  # GET /availabilities/batch_edit
  def batch_edit
    @availabilities = current_person.availabilities.upcoming
  end

  # PUT /availabilities/batch_update
  def batch_update 
    for av in params[:availabilities]
      availability = Availability.find(av[:id])
      availability.update_attributes({:time => av[:time]})
    end

    respond_to do |format|
      format.html { redirect_to staff_availabilities_url }
      format.json { head :ok }
    end
  end
end
