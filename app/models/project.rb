class Project < ActiveRecord::Base
  attr_accessible :dataset_url, :description, :owner_id, :status, :title, :first_spec, :second_spec, :third_spec, :pitch

  # Relations
  #resources
	#comments
	#tags
	has_many :collaborations, foreign_key: 'project_id'
	has_many :collaborators, through: :collaborations, class_name: "User", source: :user

	belongs_to :creator, class_name: "User"

	# Validations
	validates :description, :title, :status, :pitch, presence: true
	validates :pitch, length: { maximum: 140 }

	# Additionals
	acts_as_voteable
	acts_as_commentable

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

	def update_likes_counter
    self.likes_counter = self.votes_count
    self.save
  end

end
