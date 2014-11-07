class Evaluation < ActiveRecord::Base
  attr_accessible :evaluation_file

  belongs_to :challenges
  belongs_to :judges
end
