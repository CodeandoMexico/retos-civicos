class Subscriber < ActiveRecord::Base
  attr_accessible :email

  belongs_to :organization
  validates :email, uniqueness: { scope: :organization_id }

  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/

end
