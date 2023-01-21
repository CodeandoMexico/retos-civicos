class CreateJudges < ActiveRecord::Migration[5.0]
  def change
    create_table :judges, &:timestamps
  end
end
