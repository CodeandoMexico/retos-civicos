class AddOrganizationIdToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :organization_id, :integer
    add_index :challenges, :organization_id
  end
end
