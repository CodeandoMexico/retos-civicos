class RemoveCompanyNameColumnFromMembers < ActiveRecord::Migration[5.2]
  def up
    remove_column :members, :company_name
  end

  def down
    add_column :members, :company_name, :string
  end
end
