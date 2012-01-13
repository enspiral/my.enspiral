class Project < ActiveRecord::Base

  STATUSES = ['active','inactive']

  belongs_to :customer
  has_many :project_memberships, :dependent => :delete_all
  has_many :people, :through => :project_memberships

  validates_presence_of :status, :name
  validates_inclusion_of :status, :in => STATUSES

  mount_uploader :image, ProjectUploader

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
