class AddAcceptedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :accepted, :boolean
  end
end
