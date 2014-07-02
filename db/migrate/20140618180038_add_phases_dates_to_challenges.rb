class AddPhasesDatesToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :ideas_phase_due_on, :date
    add_column :challenges, :ideas_selection_phase_due_on, :date
  end
end
