class User < ActiveRecord::Base

  attr_accessible :avatar, :email, :name, :nickname

  # Relations
  has_many :authentications, dependent: :destroy
  has_many :created_projects, foreign_key: "creator_id", class_name: "Project"
  has_many :collaborations, foreign_key: 'user_id'
  has_many :collaborating_in, through: :collaborations, class_name: "Project", source: :project

  # Additionals
  acts_as_voter

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], nickname: auth["info"]["nickname"], email: auth["info"]["email"])
    user.authentications.build(provider: auth["provider"], uid: auth["uid"])
    user.save
    user
  end

  def to_s
    name ? name : nickname
  end

  def collaborating_in?(project)
    Collaboration.where(user_id: self.id, project_id: project.id).blank? ? false : true
  end

end
