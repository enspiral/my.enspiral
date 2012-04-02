require 'spec_helper'

describe Staff::PeopleController do
  context "when user balances is called" do
    context "as an admin" do
      before(:each) do
        log_in User.make(:admin)
        @person = Person.make!
        make_financials(@person)
      end

      it "without a limit should return all of them" do
        get :balances, :person_id => @person
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end

      it "with a limit should return a subset of balances" do
        get :balances, :person_id => @person, :limit => 2
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"]]"
      end
    end
  end
end
