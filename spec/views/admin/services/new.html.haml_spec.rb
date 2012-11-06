require 'spec_helper'

describe "admin/services/new" do
  before(:each) do
    assign(:admin_service, stub_model(Admin::Service).as_new_record)
  end

  it "renders new admin_service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_services_path, :method => "post" do
    end
  end
end
