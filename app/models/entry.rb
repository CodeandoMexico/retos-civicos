class Entry < ActiveRecord::Base
  include Reportable

  attr_accessible :image, :live_demo_url, :name, :description, :member_id,
    :url, :technologies, :company_name

  belongs_to :member
  belongs_to :challenge
  validates :name, :description, :live_demo_url, presence: true
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
end
