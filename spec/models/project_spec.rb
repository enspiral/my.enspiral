require 'spec_helper'

describe Project do
  before(:each) do
    @project = Project.make!
  end

  it {should belong_to(:customer)} 
  it {should have_many(:people)}

  it "should not save with an invalid status" do
    @project.status = '@#$%^&*'
    @project.save.should be_false
  end
end
