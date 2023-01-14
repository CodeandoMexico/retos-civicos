class CreateCollaborations < ActiveRecord::Migration[5.2]
  def change
    create_table :collaborations do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
