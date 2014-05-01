class AddTechnologiesToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :technologies, :text
  end
end
