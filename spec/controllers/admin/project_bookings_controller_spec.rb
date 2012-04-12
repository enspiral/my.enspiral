require 'spec_helper'

describe Admin::ProjectBookingsController do
  before(:each) do
    @user = User.make!(:admin)
    @person = Person.make! :user => @user

    log_in @user
  end

  describe "GET /admin/capacity" do
    before(:each) do
      @person_1 = Person.make! :default_hours_available => 40
      @person_2 = Person.make! :default_hours_available => 40

      @project_1 = Project.make!
      @project_2 = Project.make!

      @pm_1 = ProjectMembership.make! :project => @project_1, :person => @person_1
      @pm_2 = ProjectMembership.make! :project => @project_2, :person => @person_1

      @pm_3 = ProjectMembership.make! :project => @project_1, :person => @person_2
      @pm_4 = ProjectMembership.make! :project => @project_2, :person => @person_2

      @pb_1 = ProjectBooking.make! :project_membership => @pm_1, :week => Date.today.beginning_of_week, :time => 20
      @pb_2 = ProjectBooking.make! :project_membership => @pm_2, :week => Date.today.beginning_of_week, :time => 20

   end

    it 'gets a list of all people and their available hours for the next 5 weeks' do
      get :index
      people_capacity = assigns(:peoples_capacity)
      people_capacity[@person_1][(Date.today).beginning_of_week].should eq(40)
      people_capacity[@person_1][(Date.today + 1.week).beginning_of_week].should eq(0)

      people_capacity[@person_2][(Date.today).beginning_of_week].should eq(0)
    end

    it 'shows a persons project bookings' do
      get :person, :id => @person_1.id
      response.should be_success
    end

    it 'assigns formatted dates when no dates are given' do
      get :index
      assigns(:formatted_dates)[0].should eq('This Week')
      assigns(:formatted_dates)[1].should eq('Next Week')
      assigns(:formatted_dates)[2].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
    end

    it 'assigns formatted dates when dates are given' do
      get :index, :dates => [Date.today + 1.week, Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks]
      assigns(:formatted_dates)[0].should eq('Next Week')
      assigns(:formatted_dates)[1].should eq((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
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

  end
end
