require 'spec_helper'

describe "admin/cities/index.html.erb" do
  before(:each) do
    assign(:cities, [])
  end

  it "renders a list of cities" do
    render
  end
end
