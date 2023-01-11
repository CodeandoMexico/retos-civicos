class BrigadeProjectsUser < ActiveRecord::Base
  belongs_to :brigade_project
  belongs_to :user
end
