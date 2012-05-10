class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :person
  belongs_to :customer
  belongs_to :company
  has_many :project_memberships, :dependent => :delete_all
  has_many :project_membership_leads, class_name: 'ProjectMembership', conditions: {is_lead: true}
  has_many :people, through: :project_memberships
  has_many :leads, through: :project_membership_leads, source: 'person'
  has_many :invoices
  belongs_to :account, :dependent => :destroy
  delegate :default_commission, to: :company
  delegate :accounts, to: :company

  scope :active, where(status: 'active')
  accepts_nested_attributes_for :project_memberships, :reject_if => :all_blank, :allow_destroy => true

  validates_presence_of :status, :name, :company, :customer
  validates_inclusion_of :status, :in => STATUSES

  after_initialize do
    self.status ||= 'active'
  end

  before_validation do
    self.company = self.customer.company if customer
  end

  before_create :build_account

  define_index do
    has :company_id
    has people(:id), as: :project_people_ids
    indexes :name
    indexes customer(:name), as: :project_customer_name
    indexes [people(:first_name), people(:last_name)], as: :project_people_name
  end

  def self.where_status(status)
    if status == 'all'
      scoped
    elsif STATUSES.include?(status)
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where('status = ?', status)
    else
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where('status = ?', 'active')
    end
  end


end
