require 'spec_helper'

describe Staff::DashboardController do
  describe "admin member" do
    before(:each) do
      person = Person.make!(:admin)
      log_in person.user
    end

    describe "GET 'dashboard'" do
      it "should be successful" do
        get 'dashboard'
        response.should be_success
      end
    end
  end
end
