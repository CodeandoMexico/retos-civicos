class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    if user.organization?
      #Challenge access
      can [:new, :create], Challenge
      can [:edit, :update, :cancel], Challenge do |challenge|
        challenge.organization == user.userable
      end

      #Comment access
      can [:create, :reply], Comment 

      can [:like], Comment do |comment|
        comment.user != user
      end

      #Organization access
      can [:edit, :update], Organization do |organization|
        organization == user.userable
      end
    end
    
    #if user.admin?
      #can :manage, :all
    #elsif user.member?
      #can :manage, Challenge do |c|
        #c.creator == user
      #end
    #else
      #can :read, :all
    #end
  end
end
