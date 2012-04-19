class CompanyMembership < ActiveRecord::Base
  attr_accessible :admin, :company_id, :person_id, :company, :person
  belongs_to :company
  belongs_to :person
  validates_uniqueness_of :person_id, scope: :company_id
end
