class AddWebsiteToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :website, :string
  end
end
