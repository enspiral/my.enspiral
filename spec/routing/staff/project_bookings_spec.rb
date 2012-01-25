require "spec_helper"

describe Staff::ProjectBookingsController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/capacity").should route_to("staff/project_bookings#index")
    end

    it "routes to #edit" do
      assert_routing({ :path => "/staff/capacity/edit", :method => :get }, { :action => "edit", :controller => "staff/project_bookings" })
    end

  end
end
