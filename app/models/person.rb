class Person < ActiveRecord::Base
  is_gravtastic! :rating => 'PG'
  
  has_many :worked_on, :dependent => :destroy
  has_many :projects, :through => :worked_on
  
  validates_presence_of :email

  attr_accessor :full_name
  def full_name
    "#{first_name} #{last_name}"
  end
end
