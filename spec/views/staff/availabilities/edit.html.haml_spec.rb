require 'spec_helper'

describe "staff/availabilities/edit.html.haml" do
  before(:each) do
    @availability = assign(:availability, Availability.make!)
  end

  it "renders the edit availability form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_availability_path(@availability), :method => "post" do
      assert_select "input#availability_person", :name => "availability[person]"
      assert_select "input#availability_time", :name => "availability[time]"
    end
  end
end
