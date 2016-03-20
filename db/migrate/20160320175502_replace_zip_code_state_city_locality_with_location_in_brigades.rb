class ReplaceZipCodeStateCityLocalityWithLocationInBrigades < ActiveRecord::Migration
  def up
    remove_column :brigades, :zip_code
    remove_column :brigades, :city
    remove_column :brigades, :state
    remove_column :brigades, :locality
    add_column :brigades, :location, :integer, null: false
    add_index :brigades, :location
  end

  def down
    add_column :brigades, :zip_code, :string, limit: 15, null: false
    add_column :brigades, :city, :string, limit: 35, null: false
    add_column :brigades, :state, :string, limit: 25, null: false
    add_column :brigades, :locality, :string, limit: 75
    remove_column :brigades, :location
    remove_index :brigades, :location
  end
end
