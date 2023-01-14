class AddImageToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :image, :string
  end
end
