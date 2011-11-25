require 'spec_helper'

describe Booking do
before(:each) do
    @booking = Booking.make!
  end

  it {should belong_to(:person)}
  it {should belong_to(:project)}

  it "should create a new instance given valid attirbutes" do
    @booking.save.should be_true
  end

  it "should not save given an invalid time" do
    @booking.time = -1
    @booking.save.should be_false
  end

  it "should not save when there is no inputted week" do
    @booking.week = nil
    @booking.save.should be_false
  end


end
