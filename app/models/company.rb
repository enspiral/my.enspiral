class Company < ActiveRecord::Base
  scope :active, where(active: true)
  attr_accessible :default_commission, :income_account_id, :name, :support_account_id

  has_many :company_memberships, dependent: :delete_all
  has_many :people, through: :company_memberships

  has_many :company_admin_memberships,
           class_name: 'CompanyMembership',
           conditions: {admin: true}

  has_many :admins, through: :company_admin_memberships, source: :person

  has_many :accounts
  has_many :customers
  has_many :projects
  has_many :invoices

  belongs_to :support_account, class_name: 'Account'
  belongs_to :income_account, class_name: 'Account'

  validates_numericality_of :default_commission,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 1
  validates_presence_of :name, :default_commission

  after_create :ensure_main_accounts

  private
  def ensure_main_accounts
    unless self.income_account.present?
      build_income_account(name: "#{name} Income Account")
      self.income_account.company = self
      self.income_account.save!
    end

    unless self.support_account.present?
      build_support_account(name: "#{name} Support Account")
      self.support_account.company = self
      self.support_account.save!
    end

    accounts << income_account
    accounts << support_account
    self.save!
  end
end
