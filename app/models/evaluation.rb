class Evaluation < ActiveRecord::Base
  attr_accessible :judge_id, :challenge_id

  belongs_to :challenge
  belongs_to :judge
  has_many :report_cards
  has_many :entries, through: :report_cards

  validates :challenge_id, uniqueness: { scope: :judge_id }
end
