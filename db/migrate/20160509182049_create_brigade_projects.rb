class CreateBrigadeProjects < ActiveRecord::Migration
  def change
    create_table :brigade_projects do |t|
      t.string :title, :null => false
      t.text :description
      t.references :brigade, :null => false

      t.timestamps
    end
    add_index :brigade_projects, :brigade_id
  end
end
