class User < ActiveRecord::Base

  attr_accessible :avatar, :email, :name, :nickname

  # Relations
  has_many :authentications, dependent: :destroy

  has_many :created_projects, foreign_key: "creator_id", class_name: "Project"
  has_many :collaborations, foreign_key: 'user_id'
  has_many :collaborating_in, through: :collaborations, class_name: "Project", source: :project
  has_many :userskills
  has_many :skills, through: :userskills

  # Additionals
  acts_as_voter

  def self.create_with_omniauth(auth)
    user = User.new(name: auth["info"]["name"], nickname: auth["info"]["nickname"], email: auth["info"]["email"])
    user.authentications.build(provider: auth["provider"], uid: auth["uid"])
    user.apply_extra_info_from_omniauth(auth)
    user.save
    user
  end

  def to_s
    name ? name : nickname
  end

  def collaborating_in?(project)
    Collaboration.where(user_id: self.id, project_id: project.id).blank? ? false : true
  end

  def apply_extra_info_from_omniauth(auth_hash)
    case auth_hash["provider"]
    when 'linkedin'
      self.skills = get_skills_from_linkedin(auth_hash["extra"]["raw_info"])
    end
  end

  private

  def get_skills_from_linkedin(raw_info)
    skills = []
    raw_info["skills"]["values"].each do |value|
      skills << Skill.find_or_create_by_name(value.skill.name)
    end
    skills
  end

end
