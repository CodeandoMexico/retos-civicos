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
			'Votado'
		elsif signed_in?
			link_to like_project_path(project), method: :post, class: "like" do
        "<i class=\"icon-hand-right\"></i>".html_safe+project.likes_counter.to_s
      end
		else
      link_to I18n.t("project.like"), like_project_path(project), method: :post, class: "like"
		end
  end

  def collaborate_section(project)
  	if current_user == project.creator
      link_to I18n.t("project.myproject"), "", class: "colaborate"
		elsif signed_in? and current_user.collaborating_in?(project)
			link_to I18n.t("project.colaborating"), "", class: "colaborate"
		elsif signed_in?
      link_to I18n.t("project.colaborate"), collaborate_project_path(project), method: :post, class: "colaborate"
		else
			link_to I18n.t("project.colaborate"), collaborate_project_path(project), method: :post
		end
  end

end
