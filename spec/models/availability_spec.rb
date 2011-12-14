require 'spec_helper'

describe Availability do
before(:each) do
    @availability = Availability.make!
    
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

  it "should not save without a type" do
    @availability.role = nil
    @availability.save.should be_false
  end

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

  it "upcoming should get the upcoming person availabilities given an offset" do
    person = Person.make!
    for i in (0..7) do
      availability = Availability.create(:person => person, :time => 10, :week => Date.today + i.weeks, :role => 'availability')
      availability.save!
    end

    upcoming = person.availabilities.filter_availabilities.get_offset_batch(0)
    upcoming.length.should == 5

    upcoming = person.availabilities.filter_availabilities.get_offset_batch(5)
    upcoming.length.should == 3

    upcoming = person.availabilities.filter_availabilities.get_offset_batch(-1)
    upcoming.length.should == 4

  end

  it "should get the total project availabilities for all projects of a user" do
    person = Person.make!
    project1 = Project.make!
    project2 = Project.make!

    for i in (0..7) do
      availability = Availability.create(:person => person, :time => 10, :week => Date.today + i.weeks, :role => 'project', :project => project1)
      availability.save!
    end

    for i in (0..7) do
      availability = Availability.create(:person => person, :time => 10, :week => Date.today + i.weeks, :role => 'project', :project => project2)
      availability.save!
    end

    project_totals = person.availabilities.filter_projects.get_offset_batch(0).total_hours
    project_totals.length.should == 5
    project_totals[Date.today.beginning_of_week].should eq(20)
  end

end
