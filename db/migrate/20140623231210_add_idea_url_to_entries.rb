class AddIdeaUrlToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :idea_url, :string
  end
end
