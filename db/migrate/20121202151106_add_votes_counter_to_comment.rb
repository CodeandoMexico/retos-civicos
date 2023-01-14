class AddVotesCounterToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :votes_counter, :integer, default: 0
  end
end
