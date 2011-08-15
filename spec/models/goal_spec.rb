require 'spec_helper'

describe Goal do

  describe "attributes" do
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:date)}
    # One thing I don't get here is how this model essentially has 2 phases
    # Pending, and completed.  If I validate the range of score is within 0-5
    # when I create the record, will I have to have a default value of 0?
    # How do I test for > 0 < 5 on score? 
  end

  describe "associations" do
    it {should belong_to(:person)}
  end

  before(:each) do
    person = Person.make
    person.save
    @goal = Goal.make :person => person
  end

  it "should create a new instance given valid attributes" do
    @goal.save.should be_true
  end

  it "should not save with a score greater than 5 or less than 0" do
    @goal.score = 6
    @goal.should_not be_valid
    @goal.score = -3
    @goal.should_not be_valid
    @goal.score = 0
    @goal.should be_valid
  end

end
