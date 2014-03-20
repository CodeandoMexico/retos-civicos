class AddEntryLogoToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :entry_logo, :string
  end
end
