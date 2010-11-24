require 'spec_helper'

describe "notices/new.html.erb" do
  before(:each) do
    assign(:notice, stub_model(Notice).as_new_record)
  end

  it "renders new notice form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => notices_path, :method => "post" do
    end
  end
end
