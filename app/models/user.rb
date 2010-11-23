class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  ROLES = ['contractor','staff','admin']

  has_one :person

  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES

  def staff?
    role.to_sym == :staff
  end
end
