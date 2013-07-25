class Collaboration < ActiveRecord::Base
  attr_accessible :challenge_id, :user_id, :user, :challenge, :member_id

  belongs_to :user
  belongs_to :member
  belongs_to :challenge

  validates :member_id, uniqueness: { scope: :challenge_id }

  after_create :send_challenge_welcome_email

  def send_challenge_welcome_email
    ChallengeMailer.delay.welcome(self) if not self.member.email.blank?
  end

end
