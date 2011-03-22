require 'spec_helper'

describe "badges/edit.html.haml" do
  before(:each) do
    @badge = assign(:badge, stub_model(Badge,
      :name => "MyString"
    ))
    render
  end
  subject{rendered}
  it{should render_template(:partial => 'badges/_form')}
end
