class RemoveFinishDateFromChallenges < ActiveRecord::Migration
  def up
    remove_column :challenges, :finish_date
  end

  def down
    add_column :challenges, :finish_date, :date
  end
end
