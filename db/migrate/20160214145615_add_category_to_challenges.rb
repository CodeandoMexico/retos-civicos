class AddCategoryToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :category, :string, default: 'hackathon'
  end
end
