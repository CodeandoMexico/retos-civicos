class AddEvaluationCriteriaFieldToChallenge < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :evaluation_criteria, :text
  end
end
