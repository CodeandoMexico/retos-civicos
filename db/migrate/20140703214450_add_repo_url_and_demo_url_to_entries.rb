class AddRepoUrlAndDemoUrlToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :repo_url, :string
    add_column :entries, :demo_url, :string
  end
end
