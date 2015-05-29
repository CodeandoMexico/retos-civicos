class AddEvaluationsOpenedColumnToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :evaluations_opened, :boolean, default: true
  end
end
