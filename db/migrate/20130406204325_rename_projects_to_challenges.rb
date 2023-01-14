class RenameProjectsToChallenges < ActiveRecord::Migration[5.2]
  def change
    rename_table :projects, :challenges
    rename_column :activities, :project_id, :challenge_id
    rename_column :collaborations, :project_id, :challenge_id
  end
end
