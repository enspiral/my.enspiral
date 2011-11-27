require 'spec_helper'

describe Booking do
before(:each) do
    @booking = Booking.make!
    @person = Person.make!
    @project = Project.make!
    @otherproject = Project.make!

    person_project = ProjectPerson.create(:person => @person, :project => @project)
    person_project.save!
    person_project = ProjectPerson.create(:person => @person, :project => @otherproject)
    person_project.save!

    for i in (0..7) do
      booking = Booking.create(:person => @person, :project => @project, :time => 10, :week => Date.today + i.weeks)
      booking.save!
      booking = Booking.create(:person => @person, :project => @otherproject, :time => 10, :week => Date.today + i.weeks)
      booking.save!
    end
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

  it "should create a new instance given valid attirbutes" do
    @booking.save.should be_true
  end

  it "should not save given an invalid time" do
    @booking.time = -1
    @booking.save.should be_false
  end

  it "should get the all the bookings using recent.scope" do
    upcoming = @person.bookings.upcoming
    upcoming.length.should == 10
  end

  it "should only get 5 bookings given a single project" do
    project_upcoming = @project.bookings.upcoming
    project_upcoming.length.should == 5
  end

  it "should sum up the total hours booked for this week and the following 4 weeks" do
    upcoming = @person.bookings.upcoming

    upcoming_total_hours = upcoming.total_hours
    upcoming_total_hours.length.should == 5
    upcoming_total_hours.first[1].should == 20
  end

end
