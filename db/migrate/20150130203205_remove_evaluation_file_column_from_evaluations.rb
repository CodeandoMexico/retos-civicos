class RemoveEvaluationFileColumnFromEvaluations < ActiveRecord::Migration
  def up
    remove_column :evaluations, :evaluation_file
  end

  def down
    add_column :evaluations, :evaluation_file, :string
  end
end
