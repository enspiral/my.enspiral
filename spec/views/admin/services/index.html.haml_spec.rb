require 'spec_helper'

describe "admin/services/index" do
  before(:each) do
    assign(:admin_services, [
      stub_model(Admin::Service),
      stub_model(Admin::Service)
    ])
  end

  it "renders a list of admin/services" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
