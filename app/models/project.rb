class Project < ActiveRecord::Base
  attr_accessible :dataset_url, :description, :owner_id, :status, :title

  # Relations
  #resources
	#comments
	#tags
	#upvotes
	#collaborators
	has_many :collaborations, foreign_key: 'project_id'
	has_many :collaborators, through: :collaborations, class_name: "User", source: :user

	belongs_to :creator, class_name: "User"

	# Validations
	validates :description, :title, :status, presence: true

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

end
