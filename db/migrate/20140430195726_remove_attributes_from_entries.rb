class RemoveAttributesFromEntries < ActiveRecord::Migration[5.0]
  def up
    remove_column :entries, :github_url
    remove_column :entries, :team_members
    remove_column :entries, :entry_logo
  end

  def down
    add_column :entries, :github_url, :string
    add_column :entries, :team_members, :text
    add_column :entries, :entry_logo, :string
  end
end
