class AddInfographicToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :infographic, :string
  end
end
