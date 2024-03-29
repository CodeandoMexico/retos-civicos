class ActsAsCommentableWithThreadingMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :comments, force: true do |t|
      t.integer :commentable_id, default: 0
      t.string :commentable_type, default: ''
      t.text :body, default: ''
      t.integer :user_id, default: 0, null: false
      t.integer :parent_id, :lft, :rgt
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :commentable_id
  end

  def self.down
    drop_table :comments
  end
end
