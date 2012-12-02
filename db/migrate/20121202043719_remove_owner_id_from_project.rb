class RemoveOwnerIdFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :owner_id
  end

  def down
    add_column :projects, :owner_id, :integer
  end
end
