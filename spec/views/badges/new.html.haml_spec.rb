require 'spec_helper'

describe "badges/new.html.haml" do
  before(:each) do
    assign(:badge, Badge.new)
      
    render
  end
  subject{rendered}
 # it{should render_template(:layout => "application")}
  it{should render_template(:partial => "badges/_form")}
end
