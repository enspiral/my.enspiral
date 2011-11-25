require "spec_helper"

describe AvailabilitiesController do
  describe "routing" do

    it "routes to #index" do
      get("/availabilities").should route_to("availabilities#index")
    end

    it "routes to #new" do
      get("/availabilities/new").should route_to("availabilities#new")
    end

    it "routes to #show" do
      get("/availabilities/1").should route_to("availabilities#show", :id => "1")
    end

    it "routes to #edit" do
      get("/availabilities/1/edit").should route_to("availabilities#edit", :id => "1")
    end

    it "routes to #create" do
      post("/availabilities").should route_to("availabilities#create")
    end

    it "routes to #update" do
      put("/availabilities/1").should route_to("availabilities#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/availabilities/1").should route_to("availabilities#destroy", :id => "1")
    end

  end
end
