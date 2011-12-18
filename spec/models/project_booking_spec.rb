require 'spec_helper'

describe ProjectBooking do
before(:each) do
    @project_booking = ProjectBooking.make!
    @person = Person.make!
    @project = Project.make!
    @project_membership = ProjectMembership.make! :person => @person, :project => @project
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

  it "should create a new instance given valid attirbutes" do
    @project_booking.save.should be_true
  end

  it "should not save given an invalid time" do
    @project_booking.time = -1
    @project_booking.save.should be_false
  end

  it "should not save when there is no week" do
    @project_booking.week = nil
    @project_booking.save.should be_false
  end

  it "should not save when there is no Person or Project Associated" do
    @project_booking.project = nil
    @project_booking.person = nil
    @project_booking.save
    @project_booking.should have(1).error_on(:project) 
    @project_booking.should have(1).error_on(:person) 
  end

  it 'should convert a date into the beginning of the week' do
    project_booking = ProjectBooking.make!
    project_booking.week = Date.today
    project_booking.save

    ProjectBooking.last.week.should eq(Date.today.beginning_of_week)
  end

  it 'should be able to find all of a persons project bookings' do
    pb = ProjectBooking.make! :person => @person, :week => Date.today + 4.weeks, :project => @project
    project_booking = ProjectBooking.get_persons_project_bookings(@person, [Date.today + 4.weeks])
    project_booking.should eq({@project.id => {pb.week => pb.time}})
  end

  it 'should return zero if there are no bookings for a given project in a given week' do
    project_booking = ProjectBooking.get_persons_project_bookings(@person, [Date.today + 4.weeks])
    project_booking.should eq({@project.id => {(Date.today + 4.weeks).beginning_of_week => 0}})
  end


  it 'should be able to find the sum of a persons project bookings' do
    project = Project.make!
    project_membership = ProjectMembership.make! :person => @person, :project => project

    pb = ProjectBooking.make! :person => @person, :week => Date.today + 4.weeks, :project => @project, :time => 20
    pb1 = ProjectBooking.make! :person => @person, :week => Date.today + 4.weeks, :project => project, :time => 40

    project_booking_sum = ProjectBooking.get_persons_total_booked_hours(@person, [Date.today + 4.weeks])
    project_booking_sum.should eq({(Date.today + 4.weeks).beginning_of_week => 60})
  end

  it 'should return zero if there are no project bookings during a given week' do
    project = Project.make!
    project_membership = ProjectMembership.make! :person => @person, :project => project

    project_booking_sum = ProjectBooking.get_persons_total_booked_hours(@person, [Date.today + 4.weeks])
    project_booking_sum.should eq({(Date.today + 4.weeks).beginning_of_week => 0})
  end

end
