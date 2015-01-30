class Evaluation < ActiveRecord::Base
  attr_accessible :judge_id, :challenge_id
  belongs_to :challenge
  belongs_to :judge

  validates :challenge_id, uniqueness: { scope: :judge_id }
end
