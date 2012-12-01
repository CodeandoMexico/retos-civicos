class Project < ActiveRecord::Base
  attr_accessible :creator_id, :dataset_url, :description, :owner_id, :status, :title

  # Relations
  #resources
	#upvotes
	#collaborators
	#comments
	#tags

	# Validations
	validates :description, :title, :status, presence: true

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

end
