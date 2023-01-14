class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.text :text
      t.string :type
      t.integer :project_id

      t.timestamps
    end
  end
end
