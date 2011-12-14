require 'spec_helper'

describe Staff::AvailabilitiesHelper do

  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user
    @project = Project.make!

  end

  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(Staff::AvailabilitiesHelper)
  end


  it "should create a batch of personal availabilities" do
    offset = 0
    availabilities = find_or_create_availabilities_batch(offset, @person, 'availability')

    availabilities.length.should eq(5)
    availabilities[4].person.should eq(@person)
    availabilities[4].week.should eq(Date.today.beginning_of_week + (offset + 4).weeks)
  end

  it "should create a batch of personal un-availabilities" do
    offset = -5
    availabilities = find_or_create_availabilities_batch(offset, @person,'unavailability') 
    
    availabilities.length.should eq(5)
    availabilities[4].role.should eq('unavailability')
    availabilities[4].person.should eq(@person)
    availabilities[4].week.should eq(Date.today.beginning_of_week + (offset + 4).weeks)

  end

  it "should create a batch of personal project availabilities" do
    offset = 20
    availabilities = find_or_create_availabilities_batch(offset, @person, 'project', @project) 
    availabilities.length.should eq(5)

    availabilities.length.should eq(5)
    availabilities[4].role.should eq('project')
    availabilities[4].person.should eq(@person)
    availabilities[4].project.should eq(@project)
    availabilities[4].week.should eq(Date.today.beginning_of_week + (offset + 4).weeks)
  end

end
