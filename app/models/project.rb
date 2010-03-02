class Project < ActiveRecord::Base
  has_many :worked_on, :dependent => :destroy
  has_many :people, :through => :worked_on
end
