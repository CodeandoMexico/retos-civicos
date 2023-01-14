class CreateBrigadeProjectsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :brigade_projects_tags do |t|
      t.references :brigade_project
      t.references :tag

      t.timestamps
    end
  end
end
