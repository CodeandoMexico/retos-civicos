class RemoveEvaluationFileColumnFromEvaluations < ActiveRecord::Migration[5.2]
  def up
    remove_column :evaluations, :evaluation_file
  end

  def down
    add_column :evaluations, :evaluation_file, :string
  end
end
