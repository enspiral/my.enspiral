require 'spec_helper'

describe Staff::DashboardController do
  describe "staff member" do
    before(:each) do
      log_in User.make
    end

    describe "GET 'index'" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end
  end
end
