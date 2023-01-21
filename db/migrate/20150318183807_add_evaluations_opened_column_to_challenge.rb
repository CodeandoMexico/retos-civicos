class AddEvaluationsOpenedColumnToChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :evaluations_opened, :boolean, default: true
  end
end
