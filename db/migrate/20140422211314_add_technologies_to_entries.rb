class AddTechnologiesToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :technologies, :text
  end
end
