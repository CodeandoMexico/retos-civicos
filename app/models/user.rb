class User < ActiveRecord::Base

  attr_accessible :avatar, :email, :name, :nickname, :bio

  # Relations
  has_many :authentications, dependent: :destroy

  has_many :created_projects, foreign_key: "creator_id", class_name: "Project"
  has_many :collaborations, foreign_key: 'user_id'
  has_many :collaborating_in, through: :collaborations, class_name: "Project", source: :project
  has_many :userskills
  has_many :skills, through: :userskills
  has_many :comments

  # Validations
  validates :bio, length: { maximum: 255 }

  # Additionals
  acts_as_voter

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], nickname: auth["info"]["nickname"], email: auth["info"]["email"])
    authentication = user.authentications.build(provider: auth['provider'], uid: auth['uid']) 
    authentication.user = user
    authentication.apply_extra_info_from_omniauth(auth)
    user.save
    user
  end

  def to_s
    name ? name : nickname
  end

  def collaborating_in?(project)
    Collaboration.where(user_id: self.id, project_id: project.id).blank? ? false : true
  end

  def update_skills(skills = [])
    self.skills = (self.skills + skills).uniq
  end

  def avatar
    if self.authentications.pluck(:provider).include? "twitter"
      twitter_auth = self.authentications.where(provider: 'twitter').first
      "http://api.twitter.com/1/users/profile_image?id=#{twitter_auth.uid}&size=bigger"
    else
      Gravatar.new(self.email.to_s).image_url
    end
  end

end
