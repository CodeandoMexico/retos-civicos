class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new role: 'member'

    if user.admin?
      can :manage, :all
    elsif user.member?
      can :read, Project
    else
      can :read, :all
    end
  end
end
