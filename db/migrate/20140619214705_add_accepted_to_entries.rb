class AddAcceptedToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :accepted, :boolean
  end
end
