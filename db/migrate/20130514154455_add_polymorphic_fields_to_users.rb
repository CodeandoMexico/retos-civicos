class AddPolymorphicFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :userable_type, :string
    add_index :users, :userable_type
    add_column :users, :userable_id, :integer
    add_index :users, :userable_id
  end
end
