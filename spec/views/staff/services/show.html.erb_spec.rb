require 'spec_helper'

describe "staff/services/show.html.erb" do
  before(:each) do
    @service = assign(:service, stub_model(Service))
  end

  it "renders attributes in <p>" do
    render
  end
end
