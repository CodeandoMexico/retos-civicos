class AddPriceToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :price, :text
  end
end
