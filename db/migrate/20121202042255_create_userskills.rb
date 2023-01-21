class CreateUserskills < ActiveRecord::Migration[5.0]
  def change
    create_table :userskills do |t|
      t.integer :user_id
      t.integer :skill_id

      t.timestamps
    end

    add_index :userskills, :user_id
    add_index :userskills, :skill_id
  end
end
