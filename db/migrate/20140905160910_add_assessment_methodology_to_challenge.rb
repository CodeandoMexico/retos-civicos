class AddAssessmentMethodologyToChallenge < ActiveRecord::Migration[5.0]
  def change
    add_column :challenges, :assessment_methodology, :string
  end
end
