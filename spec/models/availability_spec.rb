require 'spec_helper'
require 'date'

describe Availability do
  before(:each) do
    @avaliability = Availability.make!
  end

  it {should belong_to(:person)}

  it "should create a new instance given valid attirbutes" do
    @avaliability.save.should be_true
  end

  it "should not save given an invalid time" do
    @avaliability.time = -1
    @avaliability.save.should be_false
  end
end
