class AddOptionToHideProfileOnUser < ActiveRecord::Migration
  def change
    add_column :users, :show_profile, :boolean, default: true
  end
end
