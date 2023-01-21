class AddFinishDateToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :finish_date, :date
  end
end
