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
			link_to 'Like', like_project_path(project), method: :post
		else
			link_to 'Registrate para dar Like', '#'
		end
  end

  def collaborate_section(project)
  	if current_user == project.creator
  		'Proyecto tuyo'
		elsif signed_in? and current_user.collaborating_in?(project)
			'Estás colaborando!'
		elsif signed_in?
			link_to 'Colaborar', collaborate_project_path(project), method: :post
		else
			link_to 'Registrate para colaborar', '#'
		end
  end

end
