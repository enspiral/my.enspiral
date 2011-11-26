require 'spec_helper'

describe Booking do
before(:each) do
    @booking = Booking.make!
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

  it "should get the 5 most recent bookings using recent.scope" do
    person = Person.make!
    project = Project.make!
    otherproject = Project.make!

    for i in (0..7) do
      booking = Booking.create(:person => person, :project => project, :time => 10, :week => Date.today + i.weeks)
      booking.save!
      booking = Booking.create(:person => person, :project => otherproject, :time => 10, :week => Date.today + i.weeks)
      booking.save!
    end

    upcoming = person.bookings.upcoming
    upcoming.length.should == 10

    project_upcoming = project.bookings.upcoming
    project_upcoming.length.should == 5

  end



end
