class AddVotesCounterToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :votes_counter, :integer, default: 0
  end
end
