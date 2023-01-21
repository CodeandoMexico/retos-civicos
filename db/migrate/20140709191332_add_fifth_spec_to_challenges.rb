class AddFifthSpecToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :fifth_spec, :text
  end
end
