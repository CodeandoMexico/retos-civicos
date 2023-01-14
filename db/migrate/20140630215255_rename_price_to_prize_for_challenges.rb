class RenamePriceToPrizeForChallenges < ActiveRecord::Migration[5.2]
  def up
    rename_column :challenges, :price, :prize
  end

  def down
    rename_column :challenges, :prize, :price
  end
end
