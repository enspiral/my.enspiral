class Person < ActiveRecord::Base
  has_many :projects, :through => :worked_on
end
