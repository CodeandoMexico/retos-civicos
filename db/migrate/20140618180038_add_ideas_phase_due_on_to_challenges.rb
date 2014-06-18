class AddIdeasPhaseDueOnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :ideas_phase_due_on, :date
  end
end
