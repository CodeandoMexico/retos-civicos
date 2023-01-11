class Collaboration < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  belongs_to :challenge

  validates :member_id, uniqueness: { scope: :challenge_id }
end
