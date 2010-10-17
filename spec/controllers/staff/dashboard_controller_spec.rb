require 'spec_helper'

describe Staff::DashboardController do
  setup :activate_authlogic
  
  before(:each) do
    login_as User.make
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should assign a current person" do
    end

  end
end
