class CreateBrigadeUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :brigade_users do |t|
      t.references :user
      t.references :brigade

      t.timestamps
    end
  end
end
