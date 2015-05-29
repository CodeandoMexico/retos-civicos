class AddColumnToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :evaluation_instructions, :text
  end
end
