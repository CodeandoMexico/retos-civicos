class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new role: 'member'

    if user.admin?
      can :manage, :all
    elsif user.member?
      can :manage, Challenge do |c|
        c.creator == user
      end
    else
      can :read, :all
    end
  end
end
