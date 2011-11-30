class Staff::AvailabilitiesController < Staff::Base
  # GET /availabilities
  # GET /availabilities.json
  def index
    @person = current_person
    @projects = @person.projects
    @availabilities = @person.availabilities.upcoming

    if @availabilities.length != 5
      for i in (@availabilities.length..5) do
        availability = Availability.find_or_create_by_person_id_and_week(:person_id => @person.id, :week => Date.today + i.weeks)
        if !availability.time
          availability.time = 0
        end 
        availability.save!
      end
      @availabilities = @person.availabilities.upcoming
    end

    @total_bookings = @person.bookings.upcoming
    @total_hours_booked = @total_bookings.total_hours

    
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

  # PUT /staff/batch_update
  def batch_update 
    for av in params[:availabilities]
      availability = Availability.find_or_create_by_person_id_and_week(current_person.id, :week => av[:week])
      availability.time = av[:time]
      availability.save!
    end

    respond_to do |format|
      format.html { redirect_to staff_availabilities_url }
      format.json { head :ok }
    end
  end
end
