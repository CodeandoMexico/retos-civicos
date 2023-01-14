class AddFourthSpecToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :fourth_spec, :text
  end
end
