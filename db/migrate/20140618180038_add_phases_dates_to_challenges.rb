class AddPhasesDatesToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :ideas_phase_due_on, :date
    add_column :challenges, :ideas_selection_phase_due_on, :date
  end
end
