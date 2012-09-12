class Contract < ActiveRecord::Base
  attr_accessible :for, :name, :starts_on, :ends_on, :file_name, :file_uid

  belongs_to :for, polymorphic: true
  has_many :contract_parties

  file_accessor :file

  scope :active, where(active: true)

  def parties
    contract_parties.collect {|cp| cp.contractable}
  end
end
