class Collaboration < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :user, :project

  belongs_to :user
  belongs_to :project

  validates :user_id, uniqueness: { scope: :project_id }

end
