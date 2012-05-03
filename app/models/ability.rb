class Ability
  include CanCan::Ability

  def initialize(person, company)
    if user.admin? or company.admins.include? person
      can :manage, :all
    end
  end
end
