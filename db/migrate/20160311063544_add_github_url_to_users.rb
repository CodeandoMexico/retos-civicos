class AddGithubUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :github_url, :string
  end
end
