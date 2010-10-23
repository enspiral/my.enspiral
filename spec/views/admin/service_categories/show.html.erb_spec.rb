require 'spec_helper'

describe "admin/service_categories/show.html.erb" do
  before(:each) do
    @service_category = assign(:service_category, stub_model(ServiceCategory))
  end

  it "renders attributes in <p>" do
    render
  end
end
