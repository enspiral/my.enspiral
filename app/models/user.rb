class User < ActiveRecord::Base
  include SavageBeast::UserInit
  
  has_one :person

  validates_presence_of :role
  validates_inclusion_of :role, :in => ['admin', 'staff']

  acts_as_authentic do |a|
    a.logged_in_timeout = 30.minutes
    a.login_field = 'email'
  end

  def staff?
    role.to_sym == :staff
  end

  # BEGIN Required for savage-beast
  def display_name
		person.username
	end

  def admin?
    role.to_sym == :admin
  end

  def currently_online
    false
  end

  #implmement to build search coondtitions
	# def build_search_conditions(query)
		# # query && ['LOWER(display_name) LIKE :q OR LOWER(login) LIKE :q', {:q => "%#{query}%"}]
		# query
	# end
  # END Required for savage-beast
end
