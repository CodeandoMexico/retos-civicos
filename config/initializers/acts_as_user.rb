class ActiveRecord::Base
  def self.acts_as_user
    include Userable
  end
end
