class AddInvalidReasonColumnToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :invalid_reason, :text
  end
end
