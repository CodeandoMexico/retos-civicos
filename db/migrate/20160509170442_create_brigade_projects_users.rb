class CreateBrigadeProjectsUsers < ActiveRecord::Migration
  def change
    create_table :brigade_projects_users do |t|
      t.references :brigade_project
      t.references :user

      t.timestamps
    end
    add_index :brigade_projects_users, :brigade_project_id
    add_index :brigade_projects_users, :user_id
  end
end
