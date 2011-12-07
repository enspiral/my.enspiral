class Account < ActiveRecord::Base
	belongs_to :person
  belongs_to :project

  validates_uniqueness_of :person_id, :allow_nil => true
  validates_uniqueness_of :project_id, :allow_nil => true

  has_many :transactions, :order => "date DESC, amount DESC"
  has_many :account_permissions

  def calculate_balance 
    sum = transactions.sum('amount')
    update_attribute(:balance, sum)
    sum
  end
end
