class BrigadeProjectsTag < ActiveRecord::Base
  belongs_to :brigade_project
  belongs_to :tag
end
