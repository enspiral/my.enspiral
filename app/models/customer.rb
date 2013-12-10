class Customer < ActiveRecord::Base
  scope :approved, where(approved: true)
  scope :unapproved, where(approved: false)	
  belongs_to :company
  validates_presence_of :company
  default_scope order(:name)
  has_many :invoices
  has_many :projects
  delegate :default_contribution, to: :company
  delegate :accounts, to: :company

  def approve!
    update_attribute(:approved, true)
  end 
end
