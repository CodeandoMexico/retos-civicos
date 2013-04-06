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
    challenge.creator == current_user
  end

  def like_section(challenge)
		if signed_in? and current_user.voted_for?(challenge)
			link_to "", class: "like" do
        "<i class=\"icon-thumbs-up\"></i>".html_safe+challenge.likes_counter.to_s
      end
		elsif signed_in?
			link_to like_challenge_path(challenge), method: :post, class: "like" do
        "<i class=\"icon-thumbs-up\"></i>".html_safe+challenge.likes_counter.to_s
      end
		else
      link_to t("challenges.like"), like_challenge_path(challenge), method: :post, class: "like"
		end
  end

  def collaborate_section(challenge)
  	if current_user == challenge.creator
      link_to t(".edit"), edit_challenge_path(@challenge)
		elsif signed_in? and current_user.collaborating_in?(challenge)
			link_to t(".collaborating"), "", class: "collaborate"
		elsif signed_in?
      link_to t(".collaborate"), collaborate_challenge_path(challenge), method: :post, class: "collaborate"
		else
			link_to t(".collaborate"), collaborate_challenge_path(challenge), method: :post
		end
  end

end
