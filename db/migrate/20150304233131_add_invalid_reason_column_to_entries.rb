class AddInvalidReasonColumnToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :invalid_reason, :text
  end
end
