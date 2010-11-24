require 'spec_helper'

describe "admin/service_categories/new.html.erb" do
  before(:each) do
    assign(:service_category, stub_model(ServiceCategory).as_new_record)
  end

  it "renders new service_category form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_service_categories_path, :method => "post" do
    end
  end
end
