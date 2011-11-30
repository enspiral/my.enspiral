require "spec_helper"

describe Staff::BookingsController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/bookings").should route_to("staff/bookings#index")
    end

    it "routes to #new" do
      get("/staff/bookings/new").should route_to("staff/bookings#new")
    end

    it "routes to #show" do
      get("/staff/bookings/1").should route_to("staff/bookings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff/bookings/1/edit").should route_to("staff/bookings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staff/bookings").should route_to("staff/bookings#create")
    end

    it "routes to #update" do
      put("/staff/bookings/1").should route_to("staff/bookings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff/bookings/1").should route_to("staff/bookings#destroy", :id => "1")
    end

  end
end
