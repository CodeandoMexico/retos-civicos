class Skill < ActiveRecord::Base
  attr_accessible :name

  has_many :userskills
  has_many :users, through: :userskills

  def self.find_or_create_by_name(name)
    skill = Skill.find_by_name(name)
    skill ? skill : Skill.create(name: name)
  end
end
