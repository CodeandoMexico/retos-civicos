class AddPrototypesPhaseDueOnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :prototypes_phase_due_on, :date
  end
end
