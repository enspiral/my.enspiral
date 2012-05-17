class Company < ActiveRecord::Base
  attr_accessible :default_commission, :income_account_id,
    :name, :support_account_id, :contact_name, :contact_email, :contact_phone,
    :contact_skype, :address, :country_id, :city_id, :tagline, :remove_image,
    :website, :about, :image, :retained_image

  scope :active, where(active: true)

  has_many :company_memberships, dependent: :delete_all
  has_many :people, through: :company_memberships

  has_many :featured_items, as: :resource

  has_many :company_admin_memberships,
           class_name: 'CompanyMembership',
           conditions: {admin: true}

  has_many :admins, through: :company_admin_memberships, source: :person

  has_many :accounts
  has_many :customers
  has_many :projects
  has_many :invoices

  belongs_to :country
  belongs_to :city
  belongs_to :support_account, class_name: 'Account'
  belongs_to :income_account, class_name: 'Account'

  has_one :blog

  validates_numericality_of :default_commission,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 1
  validates_presence_of :name, :default_commission

  accepts_nested_attributes_for :blog

  after_create :ensure_main_accounts
  before_save :create_slug
  after_initialize { build_blog unless self.blog }

  scope :active, where(active: true)

  image_accessor :image

  private

  def create_slug
    self.slug = self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

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
