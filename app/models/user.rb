class User < ActiveRecord::Base
  has_one :person

  validates_presence_of :role
  validates_inclusion_of :role, :in => ['admin', 'staff']

  acts_as_authentic do |a|
    a.logged_in_timeout = 30.minutes
    a.login_field = 'email'
  end


  def admin?
    role.to_sym == :admin
  end

  def staff?
    role.to_sym == :staff
  end

end
