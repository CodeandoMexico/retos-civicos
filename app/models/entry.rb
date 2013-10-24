class Entry < ActiveRecord::Base
  attr_accessible :github_url, :live_demo_url, :name, :description, :member_id

  belongs_to :member
  belongs_to :challenge

  validates :name, :description, :github_url, presence: true

end
