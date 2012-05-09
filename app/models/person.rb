class Person < ActiveRecord::Base
  extend FriendlyId
  include Gravtastic
  require 'net/http'
  require 'digest/md5'
  
  gravtastic :rating => 'PG'

  friendly_id :name, use: :slugged

  has_many :project_memberships, :dependent => :delete_all
  has_many :projects, :through => :project_memberships
  has_many :customers, :through => :projects
  has_many :notices
  has_many :comments

  has_many :people_skills, dependent: :delete_all
  has_many :people_groups, dependent: :delete_all
  has_many :skills, :through => :people_skills
  has_many :groups, :through => :people_groups

  has_many :accounts_people
  has_many :accounts, :through => :accounts_people

  has_many :funds_transfers, foreign_key: :author_id

  belongs_to :account
  validate :account_is_in_accounts

  has_many :invoice_allocations, :through => :account

  belongs_to :user, :dependent => :destroy
  belongs_to :team
  belongs_to :country
  belongs_to :city

  has_many :company_memberships, :dependent => :delete_all
  has_many :companies, through: :company_memberships, source: :company

  has_many :company_adminships, class_name: 'CompanyMembership',
           conditions: {admin: true}

  has_many :admin_companies, through: :company_adminships,
           source: :company

  accepts_nested_attributes_for :user

  validates_presence_of :user, :first_name, :last_name
  validates :baseline_income, :ideal_income, :rate,
            :numericality => true, :allow_blank => true

  after_create :confirm_setup_account

  default_scope order(:first_name)

  scope :active, where(:active => true)
  scope :public, active.where(:public => true)
  scope :private, active.where(:public => false)
  scope :featured, active.where(:featured => true)
  scope :contacts, active.where(:contact => true)

  delegate :username, to: :user
  delegate :email, to: :user
  delegate :allocated_total, to: :account
  delegate :pending_total, to: :account
  delegate :disbursed_total, to: :account

  define_index do
    indexes [first_name, last_name], :as => :name
    indexes skills(:description), as: :skills
    indexes projects(:name), as: :person_projects_name
    indexes customers(:name), as: :person_customers_name
  end

  delegate :admin?, to: :user

  def has_gravatar?
    has_gravatar
  end

  def name
    "#{first_name} #{last_name}"
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

  private

  def account_is_in_accounts
    if account.present?
      unless accounts.include? account
        errors.add(:account, 'is not in accounts')
      end
    end
  end

  def confirm_setup_account
    unless self.account
      self.account = accounts.create(name: "#{name}'s account") 
      save
    end
  end

  def as_json(options = {})
    options ||= {}
    super(options.merge(
      :methods => [ :gravatar_url ],
      :include => {
        :account => {
          :methods => [:pending_total]
          #:include => {
            ##:invoice_allocations => {
              ##:methods => [:pending]
            ##}
           #}
        }
      }
    ))
  end

end
