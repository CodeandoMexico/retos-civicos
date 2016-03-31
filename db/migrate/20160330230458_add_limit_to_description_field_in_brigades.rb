class AddLimitToDescriptionFieldInBrigades < ActiveRecord::Migration
  def change
    change_column :brigades, :description, :text, :length => 500
    change_column :brigades, :slack_url, :string, :length => 67
    change_column :brigades, :twitter_url, :string, :length => 40
  end
end
