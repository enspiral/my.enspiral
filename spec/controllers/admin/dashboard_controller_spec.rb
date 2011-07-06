require 'spec_helper'

describe Admin::DashboardController do
  describe "admin member" do
    before(:each) do
      person = Person.make!(:admin)
      log_in person.user

      person_1 = Person.make!
      person_2 = Person.make!
      person_3 = Person.make!

      
    end

    describe "GET 'dashboard'" do
      it "should be successful" do
        get 'dashboard'
        response.should be_success
      end
    end

    describe "GET 'enspiral_balances'" do
      it "should be successful" do
        get 'enspiral_balances'
        response.should be_success
      end

      it "should return a sum of user" do
        true
      end
    end
  end
end
