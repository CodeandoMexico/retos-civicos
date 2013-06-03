class Organization < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :nickname, :accepting_suscribers

  has_many :challenges
  has_many :org_suscribers

  acts_as_user

  #after_create :send_notify_admin

  def to_s
    name || nickname || email
  end

  private

  def send_notify_admin
    AdminMailer.notify_new_organization(self).deliver
  end

end
