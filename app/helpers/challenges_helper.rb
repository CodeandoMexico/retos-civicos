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
    if user_signed_in? and current_user.voted_for?(challenge)
      link_to "", class: "like" do
	"<i class=\"icon-thumbs-up\"></i>".html_safe+challenge.likes_counter.to_s
      end
    elsif user_signed_in?
      link_to like_challenge_path(challenge), method: :post, class: "like", remote: true do
	"<i class=\"icon-thumbs-up\"></i>".html_safe+challenge.likes_counter.to_s
      end
    else
      link_to t("challenges.like"), like_challenge_path(challenge), method: :post, class: "like"
    end
  end

  def collaborate_section(challenge)
    if user_signed_in? and current_user.userable == challenge.organization
      link_to t(".edit"), edit_organization_challenge_path(@challenge.organization, @challenge)
    elsif user_signed_in? and current_user.has_submitted_app?(challenge)
      link_to t(".edit_entry"), edit_challenge_entry_path(challenge, current_user.entry_for(challenge))
    elsif user_signed_in? and current_user.collaborating_in?(challenge)
      link_to t(".submit_app"), new_challenge_entry_path(challenge)
    elsif user_signed_in?
      link_to t(".collaborate"), challenge_collaborations_path(challenge), method: :post, class: "collaborate"
    else
      link_to t(".collaborate"), challenge_collaborations_path(challenge), method: :post
    end
  end

  def newsletter_helper(challenge)
    if user_signed_in? and current_user.userable == challenge.organization
      link_to t(".send_update"), send_newsletter_organization_challenge_path(@challenge.organization, @challenge)
    end
  end

end
