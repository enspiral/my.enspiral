class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :person
  belongs_to :customer
  has_many :project_memberships, :dependent => :delete_all
  has_many :people, :through => :project_memberships

  belongs_to :account, :dependent => :destroy

  validates_presence_of :status, :name
  validates_inclusion_of :status, :in => STATUSES

  def self.where_status(status)
    if status == 'all'
      scoped
    elsif STATUSES.include?(status)
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where('status = ?', status)
    else
      joins('LEFT OUTER JOIN customers ON customers.id = projects.customer_id').where("status = 'active'")
    end
  end

  after_create :create_account
end
