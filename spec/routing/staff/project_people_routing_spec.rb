require "spec_helper"

describe Staff::ProjectPeopleController do
  describe "routing" do

    it "routes to #index" do
      get("/staff/project_people").should route_to("staff/project_people#index")
    end

    it "routes to #new" do
      get("/staff/project_people/new").should route_to("staff/project_people#new")
    end

    it "routes to #show" do
      get("/staff/project_people/1").should route_to("staff/project_people#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff/project_people/1/edit").should route_to("staff/project_people#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staff/project_people").should route_to("staff/project_people#create")
    end

    it "routes to #update" do
      put("/staff/project_people/1").should route_to("staff/project_people#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff/project_people/1").should route_to("staff/project_people#destroy", :id => "1")
    end

  end
end
