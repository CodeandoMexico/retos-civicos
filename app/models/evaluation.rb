class Evaluation < ActiveRecord::Base
  attr_accessible :evaluation_file, :judge_id, :challenge_id
  belongs_to :challenge
  belongs_to :judge
end
