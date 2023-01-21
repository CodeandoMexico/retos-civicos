class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.text :text
      t.string :type
      t.integer :project_id

      t.timestamps
    end
  end
end
