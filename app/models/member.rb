class Member < ActiveRecord::Base
  attr_accessible :avatar, :email, :name, :nickname, :bio, :user
  acts_as_user

  has_many :collaborations
  has_many :challenges, through: :collaborations
  has_many :entries

  def to_s
    name || nickname || email
  end

end
