class AddShowFieldsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :first_spec, :text
    add_column :projects, :second_spec, :text
    add_column :projects, :third_spec, :text
    add_column :projects, :pitch, :string
  end
end
