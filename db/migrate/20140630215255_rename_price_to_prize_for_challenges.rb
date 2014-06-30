class RenamePriceToPrizeForChallenges < ActiveRecord::Migration
  def up
    rename_column :challenges, :price, :prize
  end

  def down
    rename_column :challenges, :prize, :price
  end
end
