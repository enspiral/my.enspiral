class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :trackable, :validatable,
  # :token_authenticatable, :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :rememberable, :encryptable, :encryptor => :authlogic_sha512

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role
  
  ROLES = ['contractor','staff','admin']

  has_one :person
  has_many :badges, :through => :badge_ownerships

  validates_presence_of :role
  validates_inclusion_of :role, :in => ROLES

  def staff?
    [:staff, :contractor].include? role.to_sym
  end
  
  def admin?
    role.to_sym == :admin
  end

  def person_name
    person.name
  end
end
