class AddLikesCounterToProject < ActiveRecord::Migration
  def change
    add_column :projects, :likes_counter, :integer, default: 0
  end
end
