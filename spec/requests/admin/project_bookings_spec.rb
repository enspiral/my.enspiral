require 'spec_helper'

describe "Staff::ProjectBookings" do

  before(:each) do
    @user = User.make!(:admin)
    @person = Person.make! :user => @user

    login(@user)
  end

  describe "GET /admin/project_bookings" do

    it 'should allow the user to get to the project admin page from the dashboard' do
      visit admin_dashboard_path
      page.should have_link("Enspiral Capacity")
      click_link "Enspiral Capacity"

      page.should have_content('Enspiralites Utilization')
    end

    it "should load the page with a direct link" do
      visit admin_capacity_path
      page.should have_content('Enspiralites Utilization')
    end

    it 'should show the user all projects, and projects that they have a membership of' do
      project = Project.make! 
      project_2 = Project.make!
      person = Person.make! :default_hours_available => 40
      project_membership = ProjectMembership.make! :person => person, :project => project
      project_booking = ProjectBooking.make! :project_membership => project_membership, :week => Date.today.beginning_of_week, :time => 20
      project_membership_2 = ProjectMembership.make! :person => person, :project => project_2
      project_booking_2 = ProjectBooking.make! :project_membership => project_membership_2, :week => Date.today.beginning_of_week, :time => 10


      visit admin_capacity_path

      page.should have_content(person.name)
      page.should have_content('75%')
      page.should have_content('0%')
    end

    it 'downloads a csv file of the capacity report' do
      project = Project.make! 
      project_2 = Project.make!
      person = Person.make! :default_hours_available => 40
      project_membership = ProjectMembership.make! :person => person, :project => project
      project_booking = ProjectBooking.make! :project_membership => project_membership, :week => Date.today.beginning_of_week, :time => 20
      project_membership_2 = ProjectMembership.make! :person => person, :project => project_2
      project_booking_2 = ProjectBooking.make! :project_membership => project_membership_2, :week => Date.today.beginning_of_week, :time => 10


      visit admin_capacity_path

      click_link 'Export to .csv'

      result = page.response_headers['Content-Type'].should == "text/csv; charset=utf-8"
    end
  end
end

