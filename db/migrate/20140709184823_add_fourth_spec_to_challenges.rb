class AddFourthSpecToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :fourth_spec, :text
  end
end
