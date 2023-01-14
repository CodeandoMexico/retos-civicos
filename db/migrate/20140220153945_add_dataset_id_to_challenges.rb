class AddDatasetIdToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :dataset_id, :string
  end
end
