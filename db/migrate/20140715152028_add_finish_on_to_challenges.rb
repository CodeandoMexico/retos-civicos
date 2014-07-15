class AddFinishOnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :finish_on, :date
  end
end
