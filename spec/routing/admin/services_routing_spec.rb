require "spec_helper"

describe Admin::ServicesController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/services").should route_to("admin/services#index")
    end

    it "routes to #new" do
      get("/admin/services/new").should route_to("admin/services#new")
    end

    it "routes to #show" do
      get("/admin/services/1").should route_to("admin/services#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/services/1/edit").should route_to("admin/services#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/services").should route_to("admin/services#create")
    end

    it "routes to #update" do
      put("/admin/services/1").should route_to("admin/services#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/services/1").should route_to("admin/services#destroy", :id => "1")
    end

  end
end
