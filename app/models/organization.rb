class Organization < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :nickname, :accepting_suscribers, :avatar

  has_many :challenges
  has_many :org_suscribers

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
    self.challenges.count == 1
  end

  private

  def send_notify_admin
    AdminMailer.notify_new_organization(self).deliver
  end

end
