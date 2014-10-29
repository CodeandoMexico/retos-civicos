class AddIsValidColumnToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :is_valid, :boolean, default: true
  end
end
