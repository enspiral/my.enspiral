require 'spec_helper'

describe "admin/service_categories/edit.html.erb" do
  before(:each) do
    @service_category = assign(:service_category, stub_model(ServiceCategory,
      :new_record? => false
    ))
  end

  it "renders the edit service_category form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_service_category_path(@service_category), :method => "post" do
    end
  end
end
