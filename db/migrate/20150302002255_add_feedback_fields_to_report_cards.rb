class AddFeedbackFieldsToReportCards < ActiveRecord::Migration[5.2]
  def change
    add_column :report_cards, :comments, :text
    add_column :report_cards, :feedback, :text
  end
end
