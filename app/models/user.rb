class User < ActiveRecord::Base
  
  ROLES = ['contractor','staff','admin']

  has_one :person

  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES

  def staff?
    role.to_sym == :staff
  end
end
