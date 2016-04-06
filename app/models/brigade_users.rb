class BrigadeUsers < ActiveRecord::Base
  belongs_to :user
  belongs_to :brigade
  # attr_accessible :title, :body
end
