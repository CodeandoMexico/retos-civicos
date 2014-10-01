class CreateDatasets < ActiveRecord::Migration
  def change
    create_table :datasets do |t|
      t.belongs_to :challenge
      t.string :guid
      t.string :format
      t.string :title
      t.string :name
      t.string :notes

      t.timestamps
    end
    add_index :datasets, :guid
  end
end
