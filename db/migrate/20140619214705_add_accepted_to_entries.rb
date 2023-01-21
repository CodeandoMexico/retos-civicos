class AddAcceptedToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :accepted, :boolean
  end
end
