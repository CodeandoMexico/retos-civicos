class AddFifthSpecToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :fifth_spec, :text
  end
end
