class Person < ActiveRecord::Base
  is_gravtastic! :rating => 'PG'
  
  has_many :worked_on, :dependent => :destroy
  has_many :projects, :through => :worked_on
  has_many :invoice_allocations
  
  has_one :account

  belongs_to :user
  belongs_to :team
  
  validates_presence_of :email

  after_create :create_account

  def name
    "#{first_name} #{last_name}"
  end

  def allocated
    invoice_allocations.inject(0) {|total,allocation| total += allocation.amount}
  end
  
  private
  def create_account
    a = Account.create(:person_id => id)
  end
end
