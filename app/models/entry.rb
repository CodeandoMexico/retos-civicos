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

  def publish!
    self.public = true
  end

  def member?(user)
    member == user.try(:userable)
  end
end
