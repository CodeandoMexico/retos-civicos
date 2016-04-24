class BrigadeUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :brigade
  attr_accessible :user_id, :brigade_id
  
  def self.follow_unfollow(u_id, b_id)
    relation = BrigadeUser.where(:user_id => u_id, :brigade_id => b_id).first
    if relation
      BrigadeUser.destroy(relation)
    else
      BrigadeUser.create({:user_id => u_id, :brigade_id => b_id})
    end
  end
  
  def self.get_relation(u_id, b_id)
    relation = BrigadeUser.where(:user_id => u_id, :brigade_id => b_id).first
    if relation
      return relation
    else
      return nil
    end
  end
end
