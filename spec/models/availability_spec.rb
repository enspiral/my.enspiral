require 'spec_helper'

describe Availability do
before(:each) do
    @availability = Availability.make!
    
  end

  it {should belong_to(:person)}

  it "should create a new instance given valid attirbutes" do
    @availability.save.should be_true
  end

  it "should not save given an invalid time" do
    @availability.time = -1
    @availability.save.should be_false
  end

  it "should not save when there is no week" do
    @availability.week = nil
    @availability.save.should be_false
  end

  it "find recent should get the 5 most recent availabilities" do
    person = Person.make!
    for i in (0..7) do
      availability = Availability.create(:person => person, :time => 10, :week => Date.today + i.weeks)
      availability.save!
    end

    upcoming = person.availabilities.upcoming
    upcoming.length.should == 5
  end

end
