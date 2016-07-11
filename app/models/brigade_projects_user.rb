class BrigadeProjectsUser < ActiveRecord::Base
  belongs_to :brigade_project
  belongs_to :user
  # attr_accessible :title, :body
end
