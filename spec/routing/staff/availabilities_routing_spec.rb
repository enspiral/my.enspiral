require "spec_helper"

describe Staff::AvailabilitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/availabilities").should route_to("staff/availabilities#index")
    end

    it "routes to #new" do
      get("/staff/availabilities/new").should route_to("staff/availabilities#new")
    end

    it "routes to #show" do
      get("/staff/availabilities/1").should route_to("staff/availabilities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff/availabilities/1/edit").should route_to("staff/availabilities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staff/availabilities").should route_to("staff/availabilities#create")
    end

    it "routes to #update" do
      put("/staff/availabilities/1").should route_to("staff/availabilities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff/availabilities/1").should route_to("staff/availabilities#destroy", :id => "1")
    end

  end
end
