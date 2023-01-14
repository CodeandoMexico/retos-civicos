class AddStartsOnToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :starts_on, :date
  end
end
