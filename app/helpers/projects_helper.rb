module ProjectsHelper

	def status_for_project
		status = []
		Project::STATUS.each do |p| 
			status << [p.to_s.humanize, p]
		end
		status
	end

end