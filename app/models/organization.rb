class Organization < ActiveRecord::Base
  attr_accessible :name, :email, :bio, :nickname
  has_many :challenges
  acts_as_user

  #after_create :send_notify_admin

  def send_notify_admin
    AdminMailer.notify_new_organization(self).deliver
  end
end
