class Judge < ActiveRecord::Base
  attr_accessible :name, :email, :avatar

  acts_as_user
  default_scope order('created_at ASC')
end
