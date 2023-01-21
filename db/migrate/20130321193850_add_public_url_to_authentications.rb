class AddPublicUrlToAuthentications < ActiveRecord::Migration[5.0]
  def change
    add_column :authentications, :public_url, :string
  end
end
