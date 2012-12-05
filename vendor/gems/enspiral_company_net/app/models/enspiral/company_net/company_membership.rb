module Enspiral
  module CompanyNet
    class CompanyMembership < ActiveRecord::Base
      ROLES = %w[contributor employee member]
      attr_accessible :admin, :company_id, :person_id, :company, :person, :role, :person_attributes
      belongs_to :company, class_name: 'Enspiral::CompanyNet::Company'
      belongs_to :person
      validates_uniqueness_of :person_id, scope: :company_id
      validates_presence_of :company, :person
      accepts_nested_attributes_for :person
    end
  end
end