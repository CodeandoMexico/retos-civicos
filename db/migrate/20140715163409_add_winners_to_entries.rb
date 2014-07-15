class AddWinnersToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :winner, :integer
  end
end
