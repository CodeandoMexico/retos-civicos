class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :oauth_token, :public_url

  belongs_to_ninsho :user

  def self.create_with_omniauth(omniauth)
    authentication = Authentication.new(provider: omniauth['provider'], uid: omniauth['uid'])
    authentication.apply_extra_info_from_omniauth(omniauth)
    authentication.save
  end

  def apply_extra_info_from_omniauth(auth_hash)
    skills = []

    case auth_hash["provider"]
    when 'linkedin'
      skills = get_skills_from_linkedin(auth_hash["extra"]["raw_info"])
    when 'github'
      skills = get_skills_from_github(auth_hash)
    end

    self.user.update_skills(skills)
  end

  private

  def get_skills_from_linkedin(raw_info)
    skills = []
    raw_info["skills"]["values"].each do |value|
      skills << Skill.find_or_create_by_name(value.skill.name)
    end
    skills
  end

  def get_skills_from_github(auth_hash)
    github = Github.new(oauth_token: auth_hash["credentials"]["token"])
    repos = github.repos.all
    languages = repos.map { |r| r["language"] }.uniq

    skills = languages.map do |language|
      Skill.find_or_create_by_name(language)
    end
    skills
  end

end
