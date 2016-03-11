class RemoveAvatarImageUrlFromBrigades < ActiveRecord::Migration
  def up
    remove_column :brigades, :avatar_image_url
  end

  def down
    add_column :brigades, :avatar_image_url, :string, :limit => 500
  end
end
