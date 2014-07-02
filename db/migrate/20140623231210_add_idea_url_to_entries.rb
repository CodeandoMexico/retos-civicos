class AddIdeaUrlToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :idea_url, :string
  end
end
