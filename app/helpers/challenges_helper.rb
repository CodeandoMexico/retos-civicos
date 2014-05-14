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

  def like_section(challenge)
    classes = "js-like btn btn-primary"

    if user_signed_in? and current_user.voted_for?(challenge)
      link_to "", class: classes do
        "#{icon('thumbs-o-up')} #{challenge.likes_counter}".html_safe
      end
    elsif user_signed_in?
      link_to like_challenge_path(challenge), method: :post, class: classes, remote: true do
        "#{icon('thumbs-o-up')} #{challenge.likes_counter}".html_safe
      end
    else
      link_to t("challenges.like"), like_challenge_path(challenge), method: :post, class: classes
    end
  end

  def collaborate_section(challenge)
    if user_signed_in?
      userable = current_user.userable
      if userable == challenge.organization
        link_to t("helpers.edit"), edit_organization_challenge_path(@challenge.organization, @challenge), class: 'btn btn-primary'
      elsif userable.has_submitted_app?(challenge)
        link_to t("helpers.edit_entry"), edit_challenge_entry_path(challenge, userable.entry_for(challenge)), class: 'btn btn-primary'
      elsif current_user.collaborating_in?(challenge)
        link_to t("helpers.submit_app"), new_challenge_entry_path(challenge), class: 'btn btn-primary'
      else
        link_to t("helpers.collaborate"), challenge_collaborations_path(challenge), method: :post, class: 'btn btn-primary'
      end
    else
      link_to t("helpers.collaborate"), challenge_collaborations_path(challenge), method: :post, class: 'btn btn-primary'
    end
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
