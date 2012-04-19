class CompanyMembership < ActiveRecord::Base
  ROLES = %w[contributor employee member]
  attr_accessible :admin, :company_id, :person_id, :company, :person, :role, :person_attributes
  belongs_to :company
  belongs_to :person
  validates_uniqueness_of :person_id, scope: :company_id
  accepts_nested_attributes_for :person
end
