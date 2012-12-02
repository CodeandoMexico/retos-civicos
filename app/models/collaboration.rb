class Collaboration < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :user, :project

  belongs_to :user
  belongs_to :project

end
