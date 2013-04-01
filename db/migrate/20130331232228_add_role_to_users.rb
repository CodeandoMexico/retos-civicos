class AddRoleToUsers < ActiveRecord::Migration
  def up
    add_column :users, :role, :string, :default => 'member'

    User.update_all role: 'member'
  end

  def down
    remove_column :users, :role
  end
end
