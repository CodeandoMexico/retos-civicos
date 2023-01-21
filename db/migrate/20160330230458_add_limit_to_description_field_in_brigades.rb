class AddLimitToDescriptionFieldInBrigades < ActiveRecord::Migration[5.0]
  def change
    change_column :brigades, :description, :text, length: 500
    change_column :brigades, :slack_url, :string, length: 67
    change_column :brigades, :twitter_url, :string, length: 40
  end
end
