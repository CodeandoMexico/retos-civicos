class RemoveCompanyPresidentFieldFromMembers < ActiveRecord::Migration[5.2]
  def up
    remove_column :members, :company_president
  end

  def down
    add_column :members, :company_president, :string
  end
end
