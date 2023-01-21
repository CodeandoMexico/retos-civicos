class AddFinishOnToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :finish_on, :date
  end
end
