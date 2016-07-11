class CreateJudges < ActiveRecord::Migration
  def change
    create_table :judges, &:timestamps
  end
end
