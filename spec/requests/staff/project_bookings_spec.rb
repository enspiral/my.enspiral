require 'spec_helper'

describe "Staff::ProjectBookings" do
  describe "GET /staff/project_bookings" do
    
    before(:each) do
      @person = Person.make!
      login(@person.user)
    end

    it "works! (now write some real specs)" do
      get staff_capacity_path
    end

    it "Shows a dashboard of the users capacity" do
      visit staff_capacity_path

      page.should have_content('Capacity')
    end
  end
end
