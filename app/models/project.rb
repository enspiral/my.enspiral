class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :person
  belongs_to :customer
  belongs_to :company
  has_many :project_memberships, :dependent => :delete_all
  has_many :people, :through => :project_memberships

  belongs_to :account, :dependent => :destroy

  validates_presence_of :status, :name, :company
  validates_inclusion_of :status, :in => STATUSES

  after_initialize do 
    self.status ||= 'active'
  end

  before_create :build_account

  define_index do
    indexes customer(:name), as: :project_customer_name
    indexes [people(:first_name), people(:last_name)], as: :project_people_name
  end

  def self.where_status(status)
    if status == 'all'
      scoped
    elsif STATUSES.include?(status)
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where('status = ?', status)
    else
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where("status = 'active'")
    end
  end


end
