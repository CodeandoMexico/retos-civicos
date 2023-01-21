class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :name
      t.string :github_url
      t.string :live_demo_url
      t.text :description
      t.text :team_members
      t.belongs_to :member
      t.belongs_to :challenge

      t.timestamps
    end
  end
end
