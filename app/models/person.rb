class Person < ActiveRecord::Base

  include Gravtastic
  require 'net/http'
  require 'digest/md5'
  
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
  belongs_to :country
  belongs_to :city

  accepts_nested_attributes_for :user
  
  validates :email, :presence => true

  after_create :create_account
  after_save :check_update_user_email

  scope :public, where(:public => true)
  scope :private, where(:public => false)
  scope :featured, where(:featured => true)
  scope :contacts, where(:contact => true)
  scope :with_gravatar, where(:has_gravatar => true)

  def name
    "#{first_name} #{last_name}"
  end

  #This is a bit weird user.display_name, calls this function... loopy loop anyone?
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

  def has_gravatar?
    if has_gravatar == true
      true
    end
  end

  def update_gravatar_status(email)
    self.has_gravatar = false
      if check_has_gravatar?(email)
        self.has_gravatar = true
      end
      self.save!
  end
  
  def transfer_funds_to another_person, transfer_amount
    return 'You have a negative account balance. Cannot proceed with funds transfer' unless self.account.balance > 0
    return 'Cannot transfer a negative amount' unless transfer_amount > 0
    return 'Cannot transfer an amount greater than your account balance' unless self.account.balance >= transfer_amount
    
    success = true
    
    self.transaction do
      from_transaction = self.account.transactions.create :creator => self,
                                                          :amount => (transfer_amount * -1),
                                                          :date => Date.today,
                                                          :description => "Fund transfer to #{another_person.name}"
                                       
      to_transaction = another_person.account.transactions.create :creator => self,
                                                                  :amount => transfer_amount,
                                                                  :date => Date.today,
                                                                  :description => "Fund transfer from #{self.name}"
                                                                  
      unless from_transaction && to_transaction
        success = 'An error occurred during the funds transfer process'
        raise ActiveRecord::Rollback
      end
    end
    
    return success
  end

  private
  def create_account
    Account.create(:person_id => id)
  end

  def check_update_user_email
    unless user.email == email
      user.email = email
      user.save!
      update_gravatar_status(email)
    end
  end
  
  def sum_allocations_less_commission allocations
    allocations.inject(0) {|total,allocation| total += allocation.amount * (1 - allocation.commission)}
  end

  def check_has_gravatar?(email, options = {})
    # Is there a Gravatar for this email? Optionally specify :rating and :timeout.
    hash = Digest::MD5.hexdigest(email.to_s.downcase)
    options = { :rating => 'x', :timeout => 2 }.merge(options)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = options[:timeout]
    response = http.request_head("/avatar/#{hash}?rating=#{options[:rating]}&default=http://gravatar.com/avatar")
    response.code != '302'
  rescue StandardError, Timeout::Error
    true  # Don't show "no gravatar" if the service is down or slow
  end
end
