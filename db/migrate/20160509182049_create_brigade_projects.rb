class CreateBrigadeProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :brigade_projects do |t|
      t.string :title, :null => false
      t.text :description
      t.references :brigade, :null => false

      t.timestamps
    end
  end
end
