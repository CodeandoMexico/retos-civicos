class Entry < ActiveRecord::Base
  attr_accessible :image, :entry_logo, :github_url, :live_demo_url, :name,
    :description, :member_id, :team_members

  belongs_to :member
  belongs_to :challenge
  validates :name, :description, :github_url, presence: true
  mount_uploader :entry_logo, EntryLogoUploader
  mount_uploader :image, EntryImageUploader

  def self.public
    where public: true
  end

  def self.report_attributes
    [:id, :name, :challenge_title, :created_at, :description,
     :live_demo_url, :technologies, :member_name, :public?]
  end

  def publish!
    self.public = true
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

  def to_report
    self.class.report_attributes.map do |report_attribute|
      self.send(report_attribute).to_s
    end
  end
end
