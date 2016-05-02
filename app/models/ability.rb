class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    grant_general_permissions(user)
    grant_permissions_for_organizations(user) if user.organization?
    grant_permissions_for_judges(user) if user.judge?
    grant_permissions_for_members(user) if user.member?
  end

  def grant_general_permissions(user)
    grant_visitor_access(user)
    grant_entry_read_access(user)
  end

  def grant_permissions_for_organizations(user)
    grant_challenge_access(user)
    grant_comment_access(user)
    grant_organization_access(user)
    grant_all_entries_access(user)
    grant_judges_access
  end

  def grant_permissions_for_judges(user)
    grant_read_challenge_access
    grant_evaluation_access(user)
    grant_entries_access(user)
  end

  def grant_permissions_for_members(user)
    grant_like_challenge_access
    grant_collaboration_access
    grant_members_access(user)
    grant_comment_access(user)
    grant_create_comment_access(user)
  end

  def grant_visitor_access(user)
    can [:edit, :update, :define_role, :grant_role], User do |u|
      user.id == u.id
    end
    can [:read], Organization
  end

  def grant_entry_read_access(user)
    can :read, Entry do |entry|
      # allow read if the user created the entry
      # or the entry is public
      entry.public? || (user.userable.present? && user.userable.id == entry.member.id)
    end
  end

  def grant_challenge_access(user)
    can [:new, :create], Challenge
    can [:edit, :update, :cancel, :send_newsletter, :mail_newsletter], Challenge do |challenge|
      challenge.organization.id == user.userable.id
    end

    can [:manage], Challenge do |challenge|
      challenge.organization_id == user.userable.id
    end
    can [:like], Challenge
  end

  def grant_comment_access(user)
    can [:like], Comment do |comment|
      comment.user.id != user.id && !user.voted_on?(comment)
    end
  end

  def grant_organization_access(user)
    can [:edit, :update, :subscribers_list, :send_newsletter, :mail_newsletter], Organization do |org|
      org.id == user.userable.id
    end
    can [:create, :reply], Comment
  end

  def grant_all_entries_access(user)
    alias_action :read, :update, :mark_valid, :mark_invalid, :publish, :accept, :winner, :remove_winner,
                 to: :all_entries_actions
    can [:all_entries_actions], Entry do |entry|
      entry.challenge.organization_id == user.userable.id
    end
  end

  def grant_judges_access
    can [:read, :create, :update], Judge
    can [:manage], Evaluation
    can [:read], ReportCard
  end

  def grant_read_challenge_access
    can [:read], Challenge
  end

  def grant_evaluation_access(user)
    can [:new, :create, :update], Evaluation do |evaluation|
      evaluation.judge_id == user.userable.id
    end
  end

  def grant_entries_access(user)
    can [:read], Entry
    can [:update], Judge do |judge|
      judge.id == user.userable.id
    end
    can [:read, :update], ReportCard do |report_card|
      report_card.evaluation.judge.id == user.userable.id
    end
  end

  def grant_like_challenge_access
    can [:like], Challenge
  end

  def grant_collaboration_access
    can [:create], Collaboration
  end

  def grant_members_access(user)
    can [:show], Member
    can [:edit, :update], Member do |member|
      user.userable.id == member.id
    end
  end

  def grant_create_comment_access(user)
    can [:create, :reply], Comment
    can [:create_or_reply_challenge_comment], Challenge

    can [:create], Entry
    can [:update], Entry do |entry|
      user.userable.id == entry.member.id
    end
  end
end
