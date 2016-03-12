class AddLocalityToBrigades < ActiveRecord::Migration
  def change
    add_column :brigades, :locality, :string, limit: 75
  end
end
