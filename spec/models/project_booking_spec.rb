require 'spec_helper'

describe ProjectBooking do
  before(:each) do
    @project_booking = ProjectBooking.make!
    @person = Person.make! :default_hours_available => 40
    @project = Project.make!
    @project_membership = ProjectMembership.make! :person => @person, :project => @project
  end

  describe 'The structure of the model' do
    it {should belong_to(:project_membership)}

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

    it "should not save when there is no ProjectMembership Associated" do
      @project_booking.project_membership = nil
      @project_booking.save
      @project_booking.should have(1).error_on(:project_membership) 
    end

    it 'should convert a date into the beginning of the week' do
      project_booking = ProjectBooking.make!
      project_booking.week = Date.today
      project_booking.save

      ProjectBooking.last.week.should eq(Date.today.beginning_of_week)
    end

    it 'should be unique based off the project_membership_id and week' do
      project_booking = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today, :time => 40
      duplicate = ProjectBooking.make :project_membership => @project_membership, :week => Date.today, :time => 40

      duplicate.should_not be_valid
    end
  end


  describe 'retrieval methods for project_bookings' do
    it 'should be able to find all of a persons project bookings' do
      pb = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 4.weeks
      projects_bookings = ProjectBooking.get_persons_projects_bookings(@person, [Date.today + 4.weeks])
      projects_bookings.should eq({@project.id => {pb.week => pb.time}})
    end

    it 'should return zero if there are no bookings for a given person in a given week' do
      project_booking = ProjectBooking.get_persons_projects_bookings(@person, [Date.today + 4.weeks])
      project_booking.should eq({@project.id => {(Date.today + 4.weeks).beginning_of_week => 0}})
    end

    it 'should return no project bookings if none exist' do
      project_booking = ProjectBooking.get_persons_project_bookings(@project_membership, [Date.today + 4.weeks])
      project_booking.should eq((Date.today + 4.weeks).beginning_of_week => 0)
    end

    it 'should be able to find all of a projects person bookings' do
      pb = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 4.weeks
      projects_bookings = ProjectBooking.get_projects_project_bookings(@project, [Date.today + 4.weeks])
      projects_bookings.should eq({@person.id => {pb.week => pb.time}})
    end
  end


  describe 'summation methods for project bookings' do
    it 'should be able to find the sum of a persons project bookings by week' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      pb = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 4.weeks, :time => 20
      pb1 = ProjectBooking.make! :project_membership => project_membership, :week => Date.today + 4.weeks, :time => 40

      project_booking_sum = ProjectBooking.get_persons_total_booked_hours_by_week(@person, [Date.today + 4.weeks])
      project_booking_sum.should eq({(Date.today + 4.weeks).beginning_of_week => 60})
    end

    it 'should return zero if there are no project bookings during a given week' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      project_booking_sum = ProjectBooking.get_persons_total_booked_hours_by_week(@person, [Date.today + 4.weeks])
      project_booking_sum.should eq({(Date.today + 4.weeks).beginning_of_week => 0})
    end

    it 'should be able to find the sum of a projects project bookings by week' do
      person = Person.make!
      project_membership = ProjectMembership.make! :person => person, :project => @project

      pb = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 4.weeks, :time => 20
      pb1 = ProjectBooking.make! :project_membership => project_membership, :week => Date.today + 4.weeks, :time => 40

      project_booking_sum = ProjectBooking.get_projects_total_booked_hours_by_week(@project, [Date.today + 4.weeks])
      project_booking_sum.should eq({(Date.today + 4.weeks).beginning_of_week => 60})
    end

    it 'should be able to find the complete sum of a projects project_bookings' do
      ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 4.weeks, :time => 20
      ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 3.weeks, :time => 40
      
      project_booking_sum = ProjectBooking.get_projects_total_booked_hours(@project)
      project_booking_sum.should eq(60)
    end
  end


  describe 'various date formatting methods' do
    it 'should return the next five weeks when sanatize_weeks is given null' do
      weeks = ProjectBooking.sanatize_weeks(nil)
      weeks[0].should eq(Date.today.beginning_of_week)
      weeks[1].should eq(Date.today.beginning_of_week + 1.weeks)
      weeks[2].should eq(Date.today.beginning_of_week + 2.weeks)
      weeks[3].should eq(Date.today.beginning_of_week + 3.weeks)
      weeks[4].should eq(Date.today.beginning_of_week + 4.weeks)
    end

    it 'should return an array of formatted dates given no values' do
      formatted_dates = ProjectBooking.get_formatted_dates(nil)
      formatted_dates[0].should eq('This Week')
      formatted_dates[1].should eq('Next Week')
      formatted_dates[2].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
    end

    it 'should return an array of formatted dates for some given dates' do
      formatted_dates = ProjectBooking.get_formatted_dates([Date.today + 2.weeks, Date.today + 3.weeks])
      formatted_dates[0].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
      formatted_dates[1].should eq((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
    end

    it 'should return an array of the next 5 weeks given a set of dates' do
      next_dates = ProjectBooking.next_weeks(ProjectBooking.sanatize_weeks(nil))
      next_dates[0].should eq((Date.today + 1.weeks).beginning_of_week)
      next_dates[1].should eq((Date.today + 2.weeks).beginning_of_week)
      next_dates[2].should eq((Date.today + 3.weeks).beginning_of_week)
      next_dates[3].should eq((Date.today + 4.weeks).beginning_of_week)
      next_dates[4].should eq((Date.today + 5.weeks).beginning_of_week)
    end

    it 'should return an array of the next 5 weeks given a negative datum' do
      next_dates = ProjectBooking.previous_weeks(ProjectBooking.sanatize_weeks(nil))
      next_dates[0].should eq((Date.today - 1.weeks).beginning_of_week)
      next_dates[1].should eq(Date.today.beginning_of_week)
      next_dates[2].should eq((Date.today + 1.weeks).beginning_of_week)
      next_dates[3].should eq((Date.today + 2.weeks).beginning_of_week)
      next_dates[4].should eq((Date.today + 3.weeks).beginning_of_week)
    end
  end

  describe 'methods to get a peoples aggregated total hours' do

    it 'should return an aggregation of everybodys total hours for the next five weeks' do
      project_booking = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today.beginning_of_week, :time => 15
      project_booking = ProjectBooking.make! :project_membership => @project_membership, :week => (Date.today + 1.week).beginning_of_week, :time => 20

      weeks = [Date.today, Date.today + 1.weeks]
      peoples_capacity = ProjectBooking.get_peoples_total_booked_hours_by_week(weeks)

      peoples_capacity[@person].should eq({Date.today.beginning_of_week => 15, (Date.today + 1.week).beginning_of_week => 20})
    end

    it 'should return an aggregation of everybodys total hours for any weeks specified' do

    end

  end
end
