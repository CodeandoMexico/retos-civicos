class Activity < ActiveRecord::Base
  attr_accessible :text, :type, :title

  belongs_to :project
end
