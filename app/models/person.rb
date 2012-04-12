class Person < ActiveRecord::Base
  mount_uploader :profile_image, ProfileImageUploader

  include Gravtastic
  require 'net/http'
  require 'digest/md5'
  
  gravtastic :rating => 'PG',
            :size => 300
  
  has_many :project_memberships, :dependent => :delete_all
  has_many :projects, :through => :project_memberships
  has_many :notices
  has_many :comments
  has_many :services

  #we should delete badges, yammer has trumped them
  has_many :badge_ownerships

  has_many :people_skills
  has_many :skills, :through => :people_skills

  has_one :account, :dependent => :destroy
  has_many :account_permissions
  has_many :accounts, :through => :account_permissions

  has_many :invoice_allocations, :through => :account

  belongs_to :user, :dependent => :destroy
  belongs_to :team
  belongs_to :country
  belongs_to :city

  accepts_nested_attributes_for :user
  
  validates_presence_of :email, :user, :first_name, :last_name

  validates :baseline_income, :ideal_income, :numericality => true, :allow_blank => true

  after_create :create_account
  after_save :check_update_user_email

  default_scope order(:first_name)

  scope :public, where(:public => true, :active => true)
  scope :private, where(:public => false, :active => true)
  scope :featured, where(:featured => true, :active => true)
  scope :contacts, where(:contact => true, :active => true)
  scope :with_gravatar, where(:has_gravatar => true)
  scope :active, where(:active => true)

  def name
    "#{first_name} #{last_name}"
  end

  #This is a bit weird user.display_name, calls this function... loopy loop anyone?
  def username
    user.username
  end

  def deactivate
    raise "Account balance is not 0" if account.balance != 0
    update_attribute(:active, false)
    account.update_attribute(:active, false)
    user.update_attribute(:active, false)
  end

  def activate
    update_attribute(:active, true)
    user.update_attribute(:active, true)
  end
  
  def allocated_total
    account.allocated_total
  end

  def pending_total
    account.pending_total
  end

  def disbursed_total
    account.disbursed_total
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
  
  #move to account
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

  def self.gravatar_url
    self.gravatar_url
  end
  
  def as_json(options = {})
    options ||= {}                                                                                                                                 
    super(options.merge(
      :methods => [ :gravatar_url ]
    )) 
  end

  def check_has_gravatar?(email, options = {})
    if ENV["RAILS_ENV"] == 'test'
      return true
    end
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
