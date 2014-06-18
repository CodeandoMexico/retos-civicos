class AddPublishedOnToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :published_on, :date
  end
end
