class AddIsValidColumnToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :is_valid, :boolean, default: true
  end
end
