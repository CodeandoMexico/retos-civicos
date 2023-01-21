class AddPriceToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :price, :text
  end
end
