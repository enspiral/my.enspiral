require 'spec_helper'

describe "staff/services/edit.html.erb" do
  before(:each) do
    @service = assign(:service, stub_model(Service,
      :new_record? => false
    ))
  end

  it "renders the edit service form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => staff_service_path(@service), :method => "post" do
    end
  end
end
