class AddTwitterAndFacebookUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :twitter_url, :string
    add_column :users, :facebook_url, :string
  end
end
