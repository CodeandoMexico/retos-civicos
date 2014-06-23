#Encoding: utf-8
module ChallengesHelper

  def status_for_challenge
    status = []
    Challenge::STATUS.each do |p|
      status << [p.to_s.humanize, p]
    end
    status
  end

  def can_edit_challenge?(challenge)
    challenge.organization == current_organization
  end

  def collaborate_section(challenge)
    return unless Phases.is_current?(:ideas, challenge)

    if current_member && current_member.has_submitted_app?(challenge)
      text_path = 'edit_entry'
      link_path = edit_challenge_entry_path(challenge, current_member.entry_for(challenge))
      method = :get
    elsif current_member && current_member.collaborating_in?(challenge)
      text_path = 'submit_app'
      link_path = new_challenge_entry_path(challenge)
      method = :get
    else
      text_path = 'collaborate'
      link_path = challenge_collaborations_path(challenge)
      method = :post
    end

    link_to t("helpers.#{text_path}"), link_path, method: method, class: 'btn btn-primary'
  end

  def newsletter_helper(challenge)
    if user_signed_in? and current_user.userable == challenge.organization
      link_to t("helpers.send_update"), send_newsletter_organization_challenge_path(@challenge.organization, @challenge), class: 'btn btn-primary'
    end
  end

  def check_filter(filter)
    params[filter].nil? ? '' : 'active'
  end
end
