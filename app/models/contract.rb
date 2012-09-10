class Contract < ActiveRecord::Base
  attr_accessible :for_id, :for_type, :title, :starts_on, :ends_on, :file_name, :file_uid

  belongs_to :for, polymorphic: true
  has_many :contract_parties

  def parties
    contract_parties.collect {|cp| cp.contractable}
  end
end
