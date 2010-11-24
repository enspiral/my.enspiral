require 'spec_helper'

describe "admin/cities/edit.html.erb" do
  before(:each) do
    @city = assign(:city, stub_model(City,
      :new_record? => false
    ))
  end

  it "renders the edit city form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => admin_city_path(@city), :method => "post" do
    end
  end
end
