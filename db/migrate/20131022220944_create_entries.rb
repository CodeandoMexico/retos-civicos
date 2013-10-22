class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :name
      t.string :github_url
      t.string :live_demo_url
      t.text :description
      t.belongs_to :member
      t.belongs_to :challenge

      t.timestamps
    end
  end
end
