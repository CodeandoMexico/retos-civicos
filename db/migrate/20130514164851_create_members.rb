class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, &:timestamps
  end
end
