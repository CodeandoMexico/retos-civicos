class CreateJudges < ActiveRecord::Migration[5.2]
  def change
    create_table :judges, &:timestamps
  end
end
