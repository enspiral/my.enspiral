require "spec_helper"

describe Staff::ProjectMembershipsController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/project_memberships").should raise_error
    end

    it "routes to #new" do
      get("/staff/project_memberships/new").should route_to("staff/project_memberships#new")
    end

    it "routes to #show" do
      get("/staff/project_memberships/1").should raise_error
    end

    it "routes to #edit" do
      get("/staff/project_memberships/1/edit").should raise_error
    end

    it "routes to #create" do
      post("/staff/project_memberships").should route_to("staff/project_memberships#create")
    end

    it "routes to #update" do
      put("/staff/project_memberships/update").should route_to("staff/project_memberships#update")
    end

    it "routes to #destroy" do
      delete("/staff/project_memberships/1").should route_to("staff/project_memberships#destroy", :id => "1")
    end

  end
end
