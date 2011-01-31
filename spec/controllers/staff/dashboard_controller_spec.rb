require 'spec_helper'

describe Staff::DashboardController do
  describe "staff member" do
    before(:each) do
      login_as User.make
    end

    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end

      it "should assign a current person" do
        pending
      end
    end
  end
end
