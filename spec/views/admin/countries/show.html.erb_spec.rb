require 'spec_helper'

describe "admin/countries/show.html.erb" do
  before(:each) do
    @country = assign(:country, stub_model(Country))
  end

  it "renders attributes in <p>" do
    render
  end
end
