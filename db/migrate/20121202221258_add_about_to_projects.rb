class AddAboutToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :about, :text
  end
end
