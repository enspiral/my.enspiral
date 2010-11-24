require "spec_helper"

describe Admin::CitiesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/cities" }.should route_to(:controller => "admin/cities", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/cities/new" }.should route_to(:controller => "admin/cities", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/cities/1" }.should route_to(:controller => "admin/cities", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/cities/1/edit" }.should route_to(:controller => "admin/cities", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/cities" }.should route_to(:controller => "admin/cities", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/cities/1" }.should route_to(:controller => "admin/cities", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/cities/1" }.should route_to(:controller => "admin/cities", :action => "destroy", :id => "1")
    end

  end
end
