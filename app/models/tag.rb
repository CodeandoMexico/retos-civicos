class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :brigade_projects_tags
  has_many :brigade_projects, through: :brigade_projects_tags

end
