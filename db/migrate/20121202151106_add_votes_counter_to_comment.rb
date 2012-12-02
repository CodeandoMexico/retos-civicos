class AddVotesCounterToComment < ActiveRecord::Migration
  def change
    add_column :comments, :votes_counter, :integer, default: 0
  end
end
