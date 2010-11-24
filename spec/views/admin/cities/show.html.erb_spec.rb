require 'spec_helper'

describe "admin/cities/show.html.erb" do
  before(:each) do
    @city = assign(:city, stub_model(City))
  end

  it "renders attributes in <p>" do
    render
  end
end
