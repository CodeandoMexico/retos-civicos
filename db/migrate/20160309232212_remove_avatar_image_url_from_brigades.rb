class RemoveAvatarImageUrlFromBrigades < ActiveRecord::Migration[5.0]
  def up
    remove_column :brigades, :avatar_image_url
  end

  def down
    add_column :brigades, :avatar_image_url, :string, limit: 500
  end
end
