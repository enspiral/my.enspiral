require "spec_helper"

describe Notifier do

  before(:each) do
    @user = User.make!
    @person = Person.make! :user => @user

    @dates = Array.new
    for i in (1..5)
      @dates.push(Date.today.beginning_of_week + i.weeks)
    end

    @project_bookings = ProjectBooking.get_persons_projects_bookings(@person, @dates)
    @default_time_available = @person.default_hours_available
    @project_bookings_totals = ProjectBooking.get_persons_total_booked_hours_by_week(@person, @dates)
    @formatted_dates = ProjectBooking.get_formatted_dates(@dates)

  end

  describe 'capacity notification' do

    let(:mail) { Notifier.capacity_notification(@person) }

    it "renders the headers" do
      mail.subject.should eq("Your Enspiral Capacity.")
      mail.to.should eq(["#{@person.email}"])
      mail.from.should eq(["gnome@enspiral.com"])
    end

    it 'should send a users capacity for the next 5 weeks' do
      mail.body.encoded.should have_content(@default_time_available)
      mail.body.encoded.should have_content('Next Week')
      for total in @project_bookings_totals do
        mail.body.encoded.should have_content(total)
      end
      
    end
  end
end
