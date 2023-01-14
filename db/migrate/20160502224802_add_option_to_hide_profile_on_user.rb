class AddOptionToHideProfileOnUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :show_profile, :boolean, default: true
  end
end
