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
    if user_signed_in?
      userable = current_user.userable
      if userable == challenge.organization
        link_to t("helpers.edit"), edit_organization_challenge_path(@challenge.organization, @challenge)
      elsif userable.has_submitted_app?(challenge)
        link_to t("helpers.edit_entry"), edit_challenge_entry_path(challenge, userable.entry_for(challenge))
      elsif current_user.collaborating_in?(challenge)
        link_to t("helpers.submit_app"), new_challenge_entry_path(challenge)
      else
        link_to t("helpers.collaborate"), challenge_collaborations_path(challenge), method: :post, class: "collaborate"
      end
    else
      link_to t("helpers.collaborate"), challenge_collaborations_path(challenge), method: :post
    end
  end

  def newsletter_helper(challenge)
    if user_signed_in? and current_user.userable == challenge.organization
      link_to t("helpers.send_update"), send_newsletter_organization_challenge_path(@challenge.organization, @challenge)
    end
  end

  def check_filter(filter)
    params[filter].nil? ? '' : 'active'
  end

end
