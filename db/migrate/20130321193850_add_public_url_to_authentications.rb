class AddPublicUrlToAuthentications < ActiveRecord::Migration
  def change
    add_column :authentications, :public_url, :string
  end
end
