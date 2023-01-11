class BrigadeProject < ActiveRecord::Base
  belongs_to :brigade
  has_many :brigade_projects_tags
  has_many :brigade_projects_users
  has_many :tags, through: :brigade_projects_tags
  has_many :users, through: :brigade_projects_users
  validates :title, presence: true
  validates :brigade_id, presence: true

  def self.most_relevant(brigade_id)
    BrigadeProject.where(brigade_id: brigade_id).limit(3)
  end

  def tag_names
    self.tags.pluck(:name)
  end
end
