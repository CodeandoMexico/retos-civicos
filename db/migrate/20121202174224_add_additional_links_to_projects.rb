class AddAdditionalLinksToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :additional_links, :text
  end
end
