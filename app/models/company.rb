class Company < ActiveRecord::Base
  attr_accessible :default_commission, :income_account_id, :name, :support_account_id, :s

  has_many :company_memberships
  has_many :people, through: :company_memberships

  has_many :company_admin_memberships,
           class_name: 'CompanyMembership',
           conditions: {admin: true}

  has_many :admins, through: :company_admin_memberships, source: :person

  has_many :accounts_companies
  has_many :accounts, through: :accounts_companies

  has_many :customers
  has_many :projects
  has_many :invoices

  belongs_to :support_account, class_name: 'Account'
  belongs_to :income_account, class_name: 'Account'

  validates_numericality_of :default_commission,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 1
  validates_presence_of :name

  after_create :ensure_main_accounts

  private
  def ensure_main_accounts
    create_income_account(name: "#{name} Income Account") if self.income_account.nil?
    create_support_account(name: "#{name} Support Account") if self.support_account.nil?
    save!
  end
end
