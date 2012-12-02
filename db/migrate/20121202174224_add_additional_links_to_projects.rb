class AddAdditionalLinksToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :additional_links, :text
  end
end
