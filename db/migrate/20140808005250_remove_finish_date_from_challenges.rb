class RemoveFinishDateFromChallenges < ActiveRecord::Migration[5.2]
  def up
    remove_column :challenges, :finish_date
  end

  def down
    add_column :challenges, :finish_date, :date
  end
end
