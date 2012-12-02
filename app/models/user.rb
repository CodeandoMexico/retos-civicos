class User < ActiveRecord::Base

  attr_accessible :avatar, :email, :name, :nickname

  has_many :authentications, dependent: :destroy
  has_many :created_projects, foreign_key: "creator_id", class_name: "Project"

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], nickname: auth["info"]["nickname"], email: auth["info"]["email"])
    user.authentications.build(provider: auth["provider"], uid: auth["uid"])
    user.save
    user
  end

  def to_s
    name ? name : nickname
  end

end
