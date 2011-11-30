require "spec_helper"

describe Staff::ProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/projects").should route_to("staff/projects#index")
    end

    it "routes to #new" do
      get("/staff/projects/new").should route_to("staff/projects#new")
    end

    it "routes to #show" do
      get("/staff/projects/1").should route_to("staff/projects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff/projects/1/edit").should route_to("staff/projects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staff/projects").should route_to("staff/projects#create")
    end

    it "routes to #update" do
      put("/staff/projects/1").should route_to("staff/projects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff/projects/1").should route_to("staff/projects#destroy", :id => "1")
    end

  end
end
