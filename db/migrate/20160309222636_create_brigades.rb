class CreateBrigades < ActiveRecord::Migration
  def change
    create_table :brigades do |t|
      t.string :zip_code, :limit => 15, :null => false, :unique => true
      t.string :city, :limit => 35, :null => false
      t.string :state, :limit => 20, :null => false
      t.text :description
      t.string :calendar_url, :limit => 500
      t.string :slack_url, :limit => 500
      t.string :github_url, :limit => 500
      t.string :facebook_url, :limit => 500
      t.string :twitter_url, :limit => 500
      t.string :avatar_image_url, :limit => 500
      t.string :header_image_url, :limit => 500
      t.references :user, :null => false
      t.boolean :deactivated, :null => false, :default => false

      t.timestamps
    end
    add_index :brigades, :user_id
  end
end
