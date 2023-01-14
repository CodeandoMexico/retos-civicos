class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :zip_code, limit: 5, null: false
      t.string :state, limit: 20, null: false
      t.string :city, limit: 50, null: false
      t.string :locality, limit: 50

      t.timestamps
    end
  end
end
