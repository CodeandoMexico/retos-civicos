class AddWinnersToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :winner, :integer
  end
end
