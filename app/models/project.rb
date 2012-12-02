class Project < ActiveRecord::Base
  attr_accessible :dataset_url, :description, :owner_id, :status, :title

  # Relations
  #resources
	#upvotes
	#collaborators
	#comments
	#tags
	belongs_to :creator, class_name: "User"

	# Validations
	validates :description, :title, :status, presence: true

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

end
