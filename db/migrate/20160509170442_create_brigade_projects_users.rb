class CreateBrigadeProjectsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :brigade_projects_users do |t|
      t.references :brigade_project
      t.references :user

      t.timestamps
    end
  end
end
