class AddEntryLogoToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :entry_logo, :string
  end
end
