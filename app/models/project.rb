class Project < ActiveRecord::Base
  has_many :worked_on
  has_many :people, :through => :worked_on
end
