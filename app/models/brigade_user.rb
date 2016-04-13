class BrigadeUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :brigade
  attr_accessible :user_id, :brigade_id
end
