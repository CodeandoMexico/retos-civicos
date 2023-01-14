class AddInfographicToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :infographic, :string
  end
end
