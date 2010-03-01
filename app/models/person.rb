class Person < ActiveRecord::Base
  is_gravtastic!
  
  has_many :worked_on
  has_many :projects, :through => :worked_on
end
