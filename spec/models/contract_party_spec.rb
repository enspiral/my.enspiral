require 'spec_helper'

describe ContractParty do
  before(:each) do  
    @contract = Contract.make!
    @cp = ContractParty.make!(:contract => @contract)
  end
end
