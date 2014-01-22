class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new 

    # Visitor access
    can [:edit, :update, :define_role, :set_role], User do |u|
      user.id == u.id
    end
    can [:read], Organization

    if user.organization?
      #Challenge access
      can [:new, :create], Challenge
      can [:edit, :update, :cancel, :send_newsletter, :mail_newsletter], Challenge do |challenge|
        challenge.organization.id == user.userable.id
      end

      #Comment access
      can [:like], Comment do |comment|
        comment.user.id != user.id && !user.voted_on?(comment)
      end

      #Organization access
      can [:edit, :update, :subscribers_list, :send_newsletter, :mail_newsletter], Organization do |organization|
        organization.id == user.userable.id
      end

      can [:create, :reply], Comment
      can [:create_or_reply_challenge_comment], Challenge do |challenge|
        challenge.organization_id == user.userable.id
      end
      can [:like], Challenge
    end

    if user.member?
      #Challenge access
      can [:like], Challenge

      #Collaboration access
      can [:create], Collaboration

      #Members access
      can [:edit, :update], Member do |member|
        user.userable.id == member.id
      end

      #Comment access
      can [:like], Comment do |comment|
        comment.user.id != user.id && !user.voted_on?(comment)
      end

      #Comment creation for members, restricting access through challenge
      can [:create, :reply], Comment
      can [:create_or_reply_challenge_comment], Challenge do |challenge|
        user.collaborating_in? challenge
      end

      #Entry access
      can [:create], Entry
      can [:update], Entry do |entry|
        user.userable.id = entry.member.id
      end
    end
  end
end
