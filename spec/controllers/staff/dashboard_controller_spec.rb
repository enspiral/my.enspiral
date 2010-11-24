require 'spec_helper'

describe Staff::DashboardController do
  before(:each) do
    sign_in User.make!
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
