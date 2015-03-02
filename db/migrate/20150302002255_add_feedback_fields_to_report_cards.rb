class AddFeedbackFieldsToReportCards < ActiveRecord::Migration
  def change
    add_column :report_cards, :comments, :text
    add_column :report_cards, :feedback, :text
  end
end
