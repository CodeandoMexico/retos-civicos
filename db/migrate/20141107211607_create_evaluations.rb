class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :evaluation_file
      t.belongs_to :challenge
      t.belongs_to :judge
      t.timestamps
    end
  end
end
