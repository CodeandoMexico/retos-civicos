class Collaboration < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :user, :challenge

  belongs_to :user
  belongs_to :member
  belongs_to :challenge

  validates :user_id, uniqueness: { scope: :challenge_id }
  validates :member_id, uniqueness: { scope: :challenge_id }

end
