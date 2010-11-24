require 'spec_helper'

describe "admin/countries/edit.html.erb" do
  before(:each) do
    @country = assign(:country, stub_model(Country,
      :new_record? => false
    ))
  end

  it "renders the edit country form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_country_path(@country), :method => "post" do
    end
  end
end
