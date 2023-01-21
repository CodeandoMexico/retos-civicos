class CreateReportCards < ActiveRecord::Migration[5.0]
  def change
    create_table :report_cards do |t|
      t.integer :evaluation_id
      t.integer :entry_id
      t.text :grades

      t.timestamps
    end
  end
end
