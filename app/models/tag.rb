class Tag < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 25 }
  attr_accessible :name
  has_many :brigade_projects_tags
  has_many :brigade_projects, through: :brigade_projects_tags

  def self.create_tags_from_string(tag_string)
    return [] if tag_string.nil?
    tags_array = tag_string.split(',')
    tags = []
    tags_array.each do |tag|
      new_tag = Tag.find_or_create_by_name(tag)
      tags.push(new_tag)
    end
    tags
  end
end
