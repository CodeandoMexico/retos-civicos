class AddInfographicToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :infographic, :string
  end
end
