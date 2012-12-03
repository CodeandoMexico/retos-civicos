class Project < ActiveRecord::Base

  attr_accessible :dataset_url, :description, :owner_id, :status, :title, :additional_links,
                  :first_spec, :second_spec, :third_spec, :pitch, :avatar, :about, :activities_attributes, :dataset_file

  attr_accessor :dataset_file

  mount_uploader :avatar, ProjectAvatarUploader

  # Relations
	has_many :collaborations, foreign_key: 'project_id'
	has_many :collaborators, through: :collaborations, class_name: "User", source: :user
  has_many :activities

	belongs_to :creator, class_name: "User"
	# Validations
	validates :description, :title, :status, :about, :pitch, presence: true
	validates :pitch, length: { maximum: 140 }

  accepts_nested_attributes_for :activities, :reject_if => lambda { |a| a[:text].blank? }

  before_create :upload_file

	# Additionals
	acts_as_voteable
	acts_as_commentable

  # Embeddables
  auto_html_for :description do
    simple_format
    image
    youtube width: 400, height: 250, wmode: "transparent"
    vimeo   width: 400, height: 250
    link target: "_blank", rel: "nofollow"
  end

	STATUS = [:open, :working_on, :cancelled, :finished]

	def cancel!
		self.status = :cancelled
		self.save
	end

	def update_likes_counter
    self.likes_counter = self.votes_count
    self.save
  end

  def about
    self[:about].to_s
  end

  private

  def upload_file
    return true if @dataset_file.blank?

    dataset_name = self.title.gsub(/\s/,'_').downcase

    # Upload dataset resource
    resource = CKAN::Resource.new(name: @dataset_file.original_filename, title: self.title)
    resource.content = File.read(@dataset_file.tempfile)
    resource.upload(CKAN_API_KEY)

    # Create dataset
    datastore = CKAN::Datastore.new(name: dataset_name, title: @title)
    datastore.resources = [resource]
    response = datastore.upload(CKAN_API_KEY)
    created = JSON.parse(response.body)
    self.dataset_url = created['ckan_url']
  end

end
