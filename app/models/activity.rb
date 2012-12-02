class Activity < ActiveRecord::Base
  attr_accessible :text, :type

  belongs_to :project
end
