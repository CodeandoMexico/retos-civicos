class AddWebsiteToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :website, :string
  end
end
