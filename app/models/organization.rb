class Organization < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :nickname, :accepting_subscribers, :avatar

  has_many :challenges
  has_many :subscribers

  acts_as_user

  default_scope order('created_at ASC')

  #after_create :send_notify_admin

  def to_s
    name || nickname || email
  end

  def accredit!
    self.update_attribute :accredited, true
  end

  def has_only_one_challenge?
    self.challenges.active.count == 1
  end

  def has_submitted_app?(challenge)
    false
  end

  private

  def send_notify_admin
    AdminMailer.notify_new_organization(self).deliver
  end
end
