class CreateBrigadeUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :brigade_users do |t|
      t.references :user
      t.references :brigade

      t.timestamps
    end
    add_index :brigade_users, :user_id
    add_index :brigade_users, :brigade_id
  end
end
