class Person < ActiveRecord::Base
  include Gravtastic
  
  gravtastic :rating => 'PG'
  
  has_many :worked_on, :dependent => :destroy
  has_many :projects, :through => :worked_on
  has_many :invoice_allocations
  has_many :notices
  has_many :comments
  has_many :services
  
  has_one :account, :dependent => :destroy

  belongs_to :user, :dependent => :destroy
  belongs_to :team

  accepts_nested_attributes_for :user
  
  validates_presence_of :email

  after_create :create_account

  def name
    "#{first_name} #{last_name}"
  end

  def username
    user.username
  end
  
  def allocated_total
    sum_allocations_less_commission(invoice_allocations)
  end

  def pending_total
    sum_allocations_less_commission(invoice_allocations.pending)
  end

  def disbursed_total
    sum_allocations_less_commission(invoice_allocations.disbursed)
  end

  private
  def create_account
    Account.create(:person_id => id)
  end

  def sum_allocations_less_commission allocations
    allocations.inject(0) {|total,allocation| total += allocation.amount * (1 - allocation.commission)}
  end
end
