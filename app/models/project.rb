class Project < ActiveRecord::Base
  has_many :people, :through => :worked_on
end
