require 'spec_helper'

describe "staff/availabilities/show.html.haml" do
  before(:each) do
    @availability = assign(:availability, stub_model(Availability,
      :person => nil,
      :time => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
