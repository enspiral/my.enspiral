require 'spec_helper'

describe "badges/_form.html.haml" do
  before(:each) do
    assign(:badge, Badge.new)
      
    render
  end
  subject{rendered}
  it{should have_selector(%q{input[name="badge[name]"]})}
  it{should have_selector(%q{input[name="badge[image]"]})}
end
