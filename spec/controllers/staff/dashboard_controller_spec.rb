require 'spec_helper'

describe Staff::DashboardController do
  describe "staff member" do
    before(:each) do
      person = Person.make!
      log_in person.user
    end

    describe "GET 'dashboard'" do
      it "should be successful" do
        get 'dashboard'
        response.should be_success
      end
    end

    describe "GET 'history'" do
      it "should be successful" do
        get 'history'
        response.should be_success
      end
    end
  end
end
