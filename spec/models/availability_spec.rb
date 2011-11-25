require 'spec_helper'

describe Availability do
before(:each) do
    @availability = Availability.make!
  end

  it {should belong_to(:person)}

  it "should create a new instance given valid attirbutes" do
    @availability.save.should be_true
  end

  it "should not save given an invalid time" do
    @availability.time = -1
    @availability.save.should be_false
  end

  it "should not save when there is no inputted week" do
    @availability.week = nil
    @availability.save.should be_false
  end

end
