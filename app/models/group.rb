class Group < ActiveRecord::Base
  has_many :people_groups, dependent: :delete_all
  has_many :people, :through => :people_groups

  validates :name, :presence => true
end
