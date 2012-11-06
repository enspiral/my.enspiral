require 'spec_helper'

describe "admin/services/edit" do
  before(:each) do
    @admin_service = assign(:admin_service, stub_model(Admin::Service))
  end

  it "renders the edit admin_service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_services_path(@admin_service), :method => "post" do
    end
  end
end
