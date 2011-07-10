require 'spec_helper'

describe Staff::PeopleController do
  context "when user balances is called" do
    context "as an admin" do
      before(:each) do
        log_in User.make(:admin)
        @person = Person.make!
        make_financials(@person)
      end

      it "without a limit should return all them" do
        get :balances, :person_id => @person
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end

      it "with a limit should return a subset of balances" do
        get :balances, :person_id => @person, :limit => 2
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"]]"
      end
    end

    context "as staff" do
      before(:each) do
        @person = Person.make!
        log_in @person.user
        make_financials(@person)
      end

      it "without a limit should return all them" do
        get :balances
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end

      it "with a limit should return a subset of balances" do
        get :balances, :limit => 2
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"]]"
      end

      it "should only allow the view of their own blances" do
        another_person = Person.make!
        Transaction.make!(:account => another_person.account, :date => Date.parse("2011-02-13"), :amount => 250)
        Transaction.make!(:account => another_person.account, :date => Date.parse("2011-02-14"), :amount => -250)

        get :balances
        response.body.should == "[[\"1297681200000\",\"0.0\"],[\"1297594800000\",\"0.0\"],[\"1297508400000\",\"100.0\"]]"
      end
    end
  end
end
