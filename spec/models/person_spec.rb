require 'spec_helper'

describe Person do
  describe "creating a person" do
    it "should be successful given valid attributes" do
      lambda {
        person = Person.make
        person.save!
      }.should change { Person.count }
    end

    it "should validate numericality of income fields" do
      @person = Person.create(:baseline_income => "blah", :ideal_income => "blah")
      @person.should have(1).error_on(:baseline_income)
      @person.should have(1).error_on(:ideal_income) 
    end

    it "should allow blank values of income fields" do
      @person = Person.create(:baseline_income => "", :ideal_income => "")
      @person.should_not have(1).error_on(:baseline_income)
      @person.should_not have(1).error_on(:ideal_income) 
    end
  end

  context "Active people" do
    before(:each) do
      @person = Person.make :staff
      @person.save!
    end
    it "should be active by default" do
      @person.active.should == true
      @person.user.active.should == true
    end
    it "should deactivate user" do
      @person.deactivate
      @person.active.should == false
      @person.user.active.should == false
    end

    it "should have correct active scope" do
      inactive_person = Person.make! :staff, :active => false
      Person.active.should include(@person)
      Person.active.should_not include(inactive_person)
    end
  end

  it "has many contracts" do
    @person = Person.make!
    @contract = Contract.make!(for: Project.make!, title: 'test')
    @person.contracts << @contract
    @person.contracts.should include(@contract)
  end
end
