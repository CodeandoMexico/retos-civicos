class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members, &:timestamps
  end
end
