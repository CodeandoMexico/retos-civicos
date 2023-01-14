class AddPriceToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :price, :text
  end
end
