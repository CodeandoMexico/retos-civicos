class AddTwitterAndFacebookUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_url, :string
    add_column :users, :facebook_url, :string
  end
end
