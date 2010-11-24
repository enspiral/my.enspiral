require 'spec_helper'

describe "staff/services/new.html.erb" do
  before(:each) do
    assign(:service, stub_model(Service).as_new_record)
  end

  it "renders new service form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => staff_services_path, :method => "post" do
    end
  end
end
