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

end
