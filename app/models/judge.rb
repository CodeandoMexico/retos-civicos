class Judge < ActiveRecord::Base
  acts_as_user
  default_scope order('created_at ASC')

  has_many :evaluations
  has_many :challenges, through: :evaluations
end
