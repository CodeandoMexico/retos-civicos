class AddTitleToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :title, :string
  end
end
