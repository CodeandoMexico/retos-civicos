class AddFinishDateToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :finish_date, :date
  end
end
