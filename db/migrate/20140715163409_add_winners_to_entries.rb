class AddWinnersToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :winner, :integer
  end
end
