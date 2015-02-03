class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :update, :mark_valid, :mark_invalid, :publish, :accept, :winner, :remove_winner, to: :all_entries_actions
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

      can [:manage], Challenge do |challenge|
        challenge.organization_id == user.userable.id
      end
      can [:like], Challenge

      #Comment access
      can [:like], Comment do |comment|
        comment.user.id != user.id && !user.voted_on?(comment)
      end

      #Organization access
      can [:edit, :update, :subscribers_list, :send_newsletter, :mail_newsletter], Organization do |organization|
        organization.id == user.userable.id
      end

      can [:create, :reply], Comment
      # Entries access
      can [:all_entries_actions], Entry do |entry|
        entry.challenge.organization_id == user.userable.id
      end

      # Judges access
      can [:read, :create, :update], Judge
      can [:manage], Evaluation
    end

    if user.judge?
      # evaluation access
      can [:new, :create, :update], Evaluation do |evaluation|
        evaluation.judge_id == user.userable.id
      end

      # Entries access
      # should this be limited only to evaluation entries?
      can [:read], Entry do |entry|
        # raise "judge".inspect
      end

      can [:update], Judge do |judge|
        judge.id == user.userable.id
      end

      can [:manage], ReportCard do |report_card|
        report_card.evaluation.judge == user.userable.id
      end
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
      can [:create_or_reply_challenge_comment], Challenge

      #Entry access
      can [:create], Entry
      can [:update], Entry do |entry|
        user.userable.id == entry.member.id
      end
    end
  end
end
