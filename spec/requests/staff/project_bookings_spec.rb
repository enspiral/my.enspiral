require 'spec_helper'

describe "Staff::ProjectBookings" do
  describe "GET /staff/project_bookings" do
    
    before(:each) do
      @user = User.make!
      @person = Person.make! :user => @user
      @person.default_hours_available = 40
      @person.save!

      login(@user)
    end

    describe "GET /dashboard" do
      
      before(:each) do
        @project = Project.make!
        ProjectMembership.make! :project => @project, :person => @person

        @project_bookings = Array.new
        for i in (0..8) do
          pb = ProjectBooking.make! :project => @project, :person => @person, :time => rand(40), :week => Date.today + (i).weeks
          @project_bookings.push(pb)
        end
      end

      it "Shows a dashboard of the users capacity defaulted to the following weeks" do
        visit staff_capacity_path

        page.should have_content('Capacity')

        page.should have_content('Your Default Availability')
        page.should have_content(@person.default_hours_available)

        page.should have_content('Your Total Bookings')

        page.should have_content('Free Time')

        page.should have_content('This Week')
        page.should have_content('Next Week')
        page.should have_content((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))

        page.should have_content(@project.name)
        page.should have_content(@project_bookings[0].time)
        page.should have_content(@project_bookings[1].time)
        page.should have_content(@project_bookings[2].time)
        page.should have_content(@project_bookings[3].time)
        page.should have_content(@project_bookings[4].time)
      end

      it "Shows a dashboard of the users capacity when a list of dates are given" do
        visit staff_capacity_path :dates => [Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]

        page.should have_content('Capacity')

        page.should have_content('Your Default Availability')
        page.should have_content(@person.default_hours_available)

        page.should have_content('Your Total Bookings')

        page.should have_content('Free Time')

        page.should have_content((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 5.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 6.weeks).beginning_of_week.strftime('%b %-d'))


        page.should have_content(@project.name)
        page.should have_content(@project_bookings[2].time)
        page.should have_content(@project_bookings[3].time)
        page.should have_content(@project_bookings[4].time)
        page.should have_content(@project_bookings[5].time)
        page.should have_content(@project_bookings[6].time)
      end

      it 'should be able to move forward through time using next and previous' do
        visit staff_capacity_path
        click_link 'Next'

        page.should have_content((Date.today + 5.weeks).beginning_of_week.strftime('%b %-d'))

        click_link 'Next'
        page.should have_content((Date.today + 6.weeks).beginning_of_week.strftime('%b %-d'))
      end

      it 'should be able to move forward through time using next and previous' do
        visit staff_capacity_path
        click_link 'Previous'

        page.should have_content('Last Week')

        click_link 'Previous'
        page.should have_content((Date.today - 2.weeks).beginning_of_week.strftime('%b %-d'))
      end

    end

    describe 'GET /edit' do

      before(:each) do
        @project = Project.make!
        ProjectMembership.make! :project => @project, :person => @person
      end

      it 'should be able to load the edit screen for a given project booking from the dashboard' do
        visit staff_capacity_path
        
        page.should have_link('Edit')
        click_link('Edit')
        
        page.should have_content('This Week')
        page.should have_content('Next Week')
        page.should have_content((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))
      end

      it 'should be able to load the edit screen for a given project with non default dates' do
        visit staff_capacity_path :dates => [Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]

        
        page.should have_link('Edit')
        click_link('Edit')
        
        page.should_not have_content('This Week')
        page.should_not have_content('Next Week')
        page.should have_content((Date.today + 2.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 3.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 4.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 5.weeks).beginning_of_week.strftime('%b %-d'))
        page.should have_content((Date.today + 6.weeks).beginning_of_week.strftime('%b %-d'))
      end

      it 'should be able to save a set of project bookings' do
        visit staff_capacity_edit_path :project_id => @project.id, :dates => [Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]
        
        fill_in 'project_bookings[][time]', :with => '10'

        click_button 'Save'

        ProjectBooking.find_by_project_id_and_person_id_and_week(@project.id, @person.id, (Date.today + 2.weeks).beginning_of_week).time.should eq(10)
      end

      it 'should be able to edit a persons bookings that is not the logged in user' do
        person = Person.make!
        visit staff_capacity_edit_path :project_id => @project.id, :person_id => person.id,
          :dates => [Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]

        page.should have_content("Editing #{person.name}'s Availability")
        fill_in 'project_bookings[][time]', :with => '10'

        click_button 'Save'

        ProjectBooking.find_by_project_id_and_person_id_and_week(@project.id, person.id, (Date.today + 2.weeks).beginning_of_week).time.should eq(10)
      end

    end
  end
end
