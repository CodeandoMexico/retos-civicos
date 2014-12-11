class AddEvaluationCriteriaFieldToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :evaluation_criteria, :text
  end
end
