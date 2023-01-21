class AddInvalidReasonColumnToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :invalid_reason, :text
  end
end
