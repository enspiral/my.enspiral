require 'spec_helper'

describe "staff/services/index.html.erb" do
  before(:each) do
    assign(:services, [])
  end

  it "renders a list of services" do
    render
  end
end
