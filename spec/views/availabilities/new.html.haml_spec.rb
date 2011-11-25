require 'spec_helper'

describe "availabilities/new.html.haml" do
  before(:each) do
    assign(:availability, stub_model(Availability,
      :person => nil,
      :time => 1
    ).as_new_record)
  end

  it "renders new availability form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => availabilities_path, :method => "post" do
      assert_select "input#availability_person", :name => "availability[person]"
      assert_select "input#availability_time", :name => "availability[time]"
    end
  end
end
