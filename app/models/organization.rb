class Organization < ActiveRecord::Base
  has_many :challenges
  has_many :subscribers

  validates :website, url: { allow_blank: true }, on: :update
  validates :slug, uniqueness: true

  acts_as_user

  default_scope { order('created_at ASC') }

  # after_create :send_notify_admin
  def to_s
    name || nickname || email
  end

  def admin
    user
  end

  def accredit!
    update_attribute :accredited, true
  end

  def only_one_challenge?
    challenges.active.count == 1
  end

  def submitted_app?(_challenge)
    false
  end

  private

  def send_notify_admin
    AdminMailer.notify_new_organization(self).deliver
  end
end
