class Staff::AvailabilitiesController < Staff::Base
  # GET /availabilities
  # GET /availabilities.json
  def index
    @person = current_person
    @projects = @person.projects
    @availabilities = @person.availabilities.upcoming
    @project_bookings = Hash.new

    if @availabilities.length != 5
      # If we don't have availabilities for the next 4 weeks, then create them.
      for i in (@availabilities.length..4) do
        availability = Availability.find_or_create_by_person_id_and_week(:person_id => @person.id, :week => Date.today + i.weeks)
        if !availability.time
          availability.time = @person.default_hours_available || 0
        end 
        availability.save!
      end
      @availabilities = @person.availabilities.upcoming
    end

    for project in @projects
      bookings = @person.bookings.upcoming.by_project(project.id)
      if bookings.length != 5
        # We need to create the project bookings that are not yet in the database
        for i in (bookings.length..4) do
          booking = Booking.find_or_create_by_person_id_and_project_id_and_week(@person.id, project.id, Date.today + i.weeks)
          if !booking.time
            booking.time = 0
          end 
          booking.save!
        end
      end
      @project_bookings[project.id] = @person.bookings.upcoming.by_project(project.id)
    end

    @total_hours_booked = @person.bookings.upcoming.total_hours

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
