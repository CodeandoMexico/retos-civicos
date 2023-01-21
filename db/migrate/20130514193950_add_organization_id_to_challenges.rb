class AddOrganizationIdToChallenges < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :organization_id, :integer
    add_index :challenges, :organization_id
  end
end
