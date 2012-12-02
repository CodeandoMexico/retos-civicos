class Userskill < ActiveRecord::Base

  attr_accessible :skill_id, :user_id

  belongs_to :user
  belongs_to :skill

end
