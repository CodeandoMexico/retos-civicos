class AddDatasetIdToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :dataset_id, :string
  end
end
