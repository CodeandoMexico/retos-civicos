class CreateBrigadeProjectsTags < ActiveRecord::Migration
  def change
    create_table :brigade_projects_tags do |t|
      t.references :brigade_project
      t.references :tag

      t.timestamps
    end
    add_index :brigade_projects_tags, :brigade_project_id
    add_index :brigade_projects_tags, :tag_id
  end
end
