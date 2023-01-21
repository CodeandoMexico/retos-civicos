class AddImageToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :image, :string
  end
end
