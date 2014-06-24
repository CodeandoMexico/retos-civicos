class Entry < ActiveRecord::Base
  include Reportable

  attr_accessible :image, :live_demo_url, :idea_url, :name, :description, :member_id, :url, :technologies, :company_name, :company_rfc

  belongs_to :member
  belongs_to :challenge

  validates :name, :description, :idea_url, presence: true
  mount_uploader :image, EntryImageUploader
  serialize :technologies, Array
  before_validation :validate_technologies!

  def self.public
    where public: true
  end

  def self.report_attributes
    [:id, :name, :challenge_title, :created_at, :description,
     :idea_url, :technologies_separated_by_commas, :member_name, :public?]
  end

  def publish!
    self.public = true
  end

  def accept!
    self.accepted = true
  end

  def member?(user)
    member == user.try(:userable)
  end

  def member_name
    member.name
  end

  def challenge_title
    challenge.title
  end

  def technologies_separated_by_commas
    technologies.join ', '
  end

  def technologies_options
    ENTRY_TECHNOLOGIES
  end

  private

  def validate_technologies!
    self.technologies = technologies.select do |technology|
      technology.present? && technologies_options.values.flatten.include?(technology)
    end
  end
end
