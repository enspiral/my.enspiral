require "spec_helper"

describe Staff::ServicesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/staff/services" }.should route_to(:controller => "staff/services", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/staff/services/new" }.should route_to(:controller => "staff/services", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/staff/services/1" }.should route_to(:controller => "staff/services", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/staff/services/1/edit" }.should route_to(:controller => "staff/services", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/staff/services" }.should route_to(:controller => "staff/services", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/staff/services/1" }.should route_to(:controller => "staff/services", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/staff/services/1" }.should route_to(:controller => "staff/services", :action => "destroy", :id => "1")
    end

  end
end
