require 'spec_helper'

describe "admin/countries/new.html.erb" do
  before(:each) do
    assign(:country, stub_model(Country).as_new_record)
  end

  it "renders new country form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_countries_path, :method => "post" do
    end
  end
end
