class Group < ActiveRecord::Base
  has_many :people_groups, dependent: :delete_all
  has_many :people, through: :people_groups, class_name: 'Enspiral::CompanyNet::Person'
  validates :name, presence: true
end
