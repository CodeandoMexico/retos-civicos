class AddTechnologiesToEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :technologies, :text
  end
end
