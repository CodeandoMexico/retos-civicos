class AddLocalityToBrigades < ActiveRecord::Migration[5.2]
  def change
    add_column :brigades, :locality, :string, limit: 75
  end
end
