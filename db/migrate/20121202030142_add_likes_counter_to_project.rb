class AddLikesCounterToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :likes_counter, :integer, default: 0
  end
end
