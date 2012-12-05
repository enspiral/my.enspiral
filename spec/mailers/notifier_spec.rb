require "spec_helper"

describe Notifier do

  before(:each) do
    @user = User.make!
    @person = Enspiral::CompanyNet::Person.make! :user => @user
  end

  describe 'capacity notification' do

    let(:mail) { Notifier.capacity_notification(@person) }

    it "renders the headers" do
      mail.subject.should eq("[enspiral] Your Project Bookings")
      mail.to.should eq(["#{@person.email}"])
      mail.from.should eq(["no-reply@enspiral.com"])
    end
  end
end
