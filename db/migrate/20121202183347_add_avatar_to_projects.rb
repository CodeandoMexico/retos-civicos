class AddAvatarToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :avatar, :string
  end
end
