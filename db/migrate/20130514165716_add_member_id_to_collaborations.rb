class AddMemberIdToCollaborations < ActiveRecord::Migration[5.0]
  def change
    add_column :collaborations, :member_id, :integer
    add_index :collaborations, :member_id
  end
end
