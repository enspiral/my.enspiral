require 'spec_helper'

describe Contract do
  before(:each) do 
    @project = Project.make!
    @contract = Contract.make!(:for => @project, :title => 'test')
  end
  it "has many parties" do
    @person = Person.make!
    @cp = ContractParty.make!(:contract => @contract, :contractable => @person)
    @cp.contract.should == @contract
    @contract.contract_parties.should include(@cp)

    @contract.parties.should include(@person)
  end
end
