require 'spec_helper'

describe Staff::ProjectBookingsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make!
    @project_membership = ProjectMembership.make! :person => @person, :project => @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns default_time_available as the users default time" do
      get :index
      assigns(:default_time_available).should eq(@person.default_hours_available)
    end

    it 'assigns all the project bookings that the user owns, with no dates given' do
      project_times = Hash.new
      project_times[(Date.today).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today).time
      project_times[(Date.today + 1.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 1.week).time
      project_times[(Date.today + 2.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 2.week).time
      project_times[(Date.today + 3.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 3.week).time
      project_times[(Date.today + 4.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 4.week).time


      ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 5.weeks


      get :index
      assigns(:project_bookings).should eq({@project.id => project_times})
      assigns(:person).should eq(@person)

    end

    it 'assigns formatted dates when no dates are given' do
      get :index
      assigns(:formatted_dates)[0].should eq('This Week')
      assigns(:formatted_dates)[1].should eq('Next Week')
      assigns(:formatted_dates)[2].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
    end

    it 'assigns the current weeks, next weeks and previous weeks for linking purposes' do
      get :index

      assigns(:current_weeks)[0].should eq(Date.today.beginning_of_week)
      assigns(:current_weeks)[4].should eq((Date.today + 4.weeks).beginning_of_week)
      
      assigns(:next_weeks)[0].should eq((Date.today + 1.weeks).beginning_of_week)
      assigns(:next_weeks)[4].should eq((Date.today + 5.weeks).beginning_of_week)
      
      assigns(:previous_weeks)[0].should eq((Date.today - 1.weeks).beginning_of_week)
      assigns(:previous_weeks)[4].should eq((Date.today + 3.weeks).beginning_of_week)
    end

    it 'assigns all the project bookings for the given dates that the user owns' do
      ProjectBooking.make! :project_membership => @project_membership, :week => Date.today

      project_times = Hash.new
      project_times[(Date.today + 1.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 1.week).time
      project_times[(Date.today + 2.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 2.week).time
      project_times[(Date.today + 3.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 3.week).time
      project_times[(Date.today + 4.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 4.week).time
      project_times[(Date.today + 5.week).beginning_of_week] = ProjectBooking.make!(:project_membership => @project_membership, :week => Date.today + 5.week).time



      get :index, :dates => [Date.today + 1.week, Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks]
      assigns(:project_bookings).should eq({@project.id => project_times})
    end

    it 'assigns project_bookings_sum as the sum of all the projects time for no given weeks' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      bookings_sum = Hash.new
      for i in (0..6)
        ProjectBooking.make! :project_membership => project_membership, :week => Date.today + i.weeks, :time => 20
        ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + i.weeks, :time => 30
        if i < 5
          bookings_sum[(Date.today + i.weeks).beginning_of_week] = 50
        end
      end

      get :index
      assigns(:project_bookings_totals).should eq(bookings_sum)
    end

    it 'assigns project_bookings_sum as the sum of all the projects time for the given weeks' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      bookings_sum = Hash.new
      for i in (0..6)
        ProjectBooking.make! :project_membership => project_membership, :week => Date.today + i.weeks, :time => 20
        ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + i.weeks, :time => 30
        if i > 1
          bookings_sum[(Date.today + i.weeks).beginning_of_week] = 50
        end
      end

      get :index, :dates => [Date.today + 2.week, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]
      assigns(:project_bookings_totals).should eq(bookings_sum)

    end
  end

  describe "GET edit" do
    it "assigns a given project's bookings as @project_bookings" do
      bookings = Hash.new
      for i in (0..5)
        ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + i.weeks, :time => 30
        if i > 1
          bookings[(Date.today + i.weeks).beginning_of_week] = 30
        end
      end
      bookings[(Date.today + 6.weeks).beginning_of_week] = 0

      get :edit, :person_id => @person.id, :project_id => @project.id,
        :dates => [Date.today + 2.week, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]
      assigns(:project_bookings).should eq(bookings)
    end

    it 'assigns @person and @project' do
      get :edit, :person_id => @person.id, :project_id => @project.id, 
        :dates => [Date.today + 2.week, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]
     
      assigns(:person).should eq(@person)
      assigns(:project).should eq(@project)
    end

    it "assigns formatted dates for the time given in the request" do
      get :edit, :person_id => @person.id, :project_id => @project.id,  
        :dates => [Date.today + 2.week, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]

      assigns(:formatted_dates)[0].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[1].should eq((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[2].should eq((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[3].should eq((Date.today + 5.weeks).beginning_of_week.strftime('%b %-d'))
      assigns(:formatted_dates)[4].should eq((Date.today + 6.weeks).beginning_of_week.strftime('%b %-d'))
    end

  end

  describe "PUT update" do
    before(:each) do
      @av1 = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 8
    end

    it 'creates a batch of given project_bookings' do
      put :update, :project_membership_id => @project_membership.id, 
        :project_bookings => [
          {:week => Date.today + 6.weeks, :time => 50}, 
          {:week => Date.today + 7.weeks, :time => 60}]

      ProjectBooking.find_by_project_membership_id_and_week(@project_membership.id, (Date.today + 6.weeks).beginning_of_week).time.should  eq(50)
      ProjectBooking.find_by_project_membership_id_and_week(@project_membership.id, (Date.today + 7.weeks).beginning_of_week).time.should  eq(60)
    end

    it "updates a batch of given project_bookings" do
      @av2 = ProjectBooking.make! :project_membership => @project_membership, :week => Date.today + 16

      before_time = @av2.time
      put :update, :project_membership_id => @project_membership.id,
        :project_bookings => [
          {:week => @av1.week, :time => (@av1.time + 15)}, 
          {:week => @av2.week, :time => (@av2.time + 15)}]

      ProjectBooking.find(@av1.id).time.should  eq(before_time + 15)
      ProjectBooking.find(@av2.id).time.should  eq(before_time + 15)
    end

    it "redirects to the users capacity page when update was successful and it's the logged in users membership" do
      put :update, :project_membership_id => @project_membership.id, :project_bookings => [
        {:week => @av1.week, :time => @av1.time}]
      response.should redirect_to(staff_capacity_url)
    end

    it "redirects to the project show page params[:person] is given" do
      person = Person.make!
      project_membership = ProjectMembership.make! :person => person, :project => @project
      put :update, :project_membership_id => project_membership.id, :project_bookings => [
        {:week => @av1.week, :time => @av1.time}]
      response.should redirect_to(staff_project_url(@project))
    end

  end
end

