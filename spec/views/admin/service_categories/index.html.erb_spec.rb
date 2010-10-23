require 'spec_helper'

describe "admin/service_categories/index.html.erb" do
  before(:each) do
    assign(:service_categories, [
      stub_model(ServiceCategory),
      stub_model(ServiceCategory)
    ])
  end

  it "renders a list of service_categories" do
    render
  end
end
