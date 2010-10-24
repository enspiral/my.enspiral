require "spec_helper"

describe Admin::ServiceCategoriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/service_categories" }.should route_to(:controller => "admin/service_categories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/service_categories/new" }.should route_to(:controller => "admin/service_categories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/service_categories/1" }.should route_to(:controller => "admin/service_categories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/service_categories/1/edit" }.should route_to(:controller => "admin/service_categories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/service_categories" }.should route_to(:controller => "admin/service_categories", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/service_categories/1" }.should route_to(:controller => "admin/service_categories", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/service_categories/1" }.should route_to(:controller => "admin/service_categories", :action => "destroy", :id => "1")
    end

  end
end
