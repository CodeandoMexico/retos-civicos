#Encoding: utf-8
module ProjectsHelper

	def status_for_project
		status = []
		Project::STATUS.each do |p| 
			status << [p.to_s.humanize, p]
		end
		status
	end

  def can_edit_project?(project)
    project.creator == current_user
  end

  def like_section(project)
		if signed_in? and current_user.voted_for?(project)
			link_to "", class: "like" do
        "<i class=\"icon-thumbs-up\"></i>".html_safe+project.likes_counter.to_s
      end
		elsif signed_in?
			link_to like_project_path(project), method: :post, class: "like" do
        "<i class=\"icon-thumbs-up\"></i>".html_safe+project.likes_counter.to_s
      end
		else
      link_to t("projects.like"), like_project_path(project), method: :post, class: "like"
		end
  end

  def collaborate_section(project)
  	if current_user == project.creator
      link_to t(".edit"), edit_project_path(@project)
		elsif signed_in? and current_user.collaborating_in?(project)
			link_to t(".collaborating"), "", class: "collaborate"
		elsif signed_in?
      link_to t(".collaborate"), collaborate_project_path(project), method: :post, class: "collaborate"
		else
			link_to t(".collaborate"), collaborate_project_path(project), method: :post
		end
  end

end
