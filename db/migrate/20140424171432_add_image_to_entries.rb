class AddImageToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :image, :string
  end
end
