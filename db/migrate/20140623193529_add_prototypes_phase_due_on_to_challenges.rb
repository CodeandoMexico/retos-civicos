class AddPrototypesPhaseDueOnToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :prototypes_phase_due_on, :date
  end
end
