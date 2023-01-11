class Userskill < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill
end
