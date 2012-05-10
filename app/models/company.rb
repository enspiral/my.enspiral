class Company < ActiveRecord::Base
  attr_accessible :retained_image, :default_commission, :income_account_id, :name, :support_account_id, :s
  image_accessor :image

  has_many :company_memberships, dependent: :delete_all
  has_many :people, through: :company_memberships

  has_many :featured_items, as: :resource

  has_many :company_admin_memberships,
           class_name: 'CompanyMembership',
           conditions: {admin: true}

  has_many :admins, through: :company_admin_memberships, source: :person

  has_many :accounts_companies, dependent: :delete_all
  has_many :accounts, through: :accounts_companies

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

  scope :active, where(active: true)

  private
  def ensure_main_accounts
    unless self.income_account.present?
      accounts << create_income_account(name: "#{name} Income Account") 
    end
    unless self.support_account.present?
      accounts << create_support_account(name: "#{name} Support Account")
    end
  end
end
