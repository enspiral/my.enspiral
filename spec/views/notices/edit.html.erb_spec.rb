require 'spec_helper'

describe "notices/edit.html.erb" do
  before(:each) do
    @notice = assign(:notice, stub_model(Notice,
      :new_record? => false
    ))
  end

  it "renders the edit notice form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => notice_path(@notice), :method => "post" do
    end
  end
end
