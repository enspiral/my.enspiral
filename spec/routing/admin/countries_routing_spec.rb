require "spec_helper"

describe Admin::CountriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/countries" }.should route_to(:controller => "admin/countries", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/countries/new" }.should route_to(:controller => "admin/countries", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/countries/1" }.should route_to(:controller => "admin/countries", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/countries/1/edit" }.should route_to(:controller => "admin/countries", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/countries" }.should route_to(:controller => "admin/countries", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/countries/1" }.should route_to(:controller => "admin/countries", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/countries/1" }.should route_to(:controller => "admin/countries", :action => "destroy", :id => "1")
    end

  end
end
