class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.integer :creator_id
      t.integer :owner_id
      t.string :status, default: 'open'
      t.string :dataset_url

      t.timestamps
    end
  end
end
