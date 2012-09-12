class ContractParty < ActiveRecord::Base
  attr_accessible :contract, :contractable 

  belongs_to :contractable, :polymorphic => true
  belongs_to :contract
end
