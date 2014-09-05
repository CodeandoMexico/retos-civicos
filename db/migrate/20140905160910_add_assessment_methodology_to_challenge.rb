class AddAssessmentMethodologyToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :assessment_methodology, :string
  end
end
