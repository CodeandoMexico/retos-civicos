class AddTitleToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :title, :string
  end
end
