class AddStartsOnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :starts_on, :date
  end
end
