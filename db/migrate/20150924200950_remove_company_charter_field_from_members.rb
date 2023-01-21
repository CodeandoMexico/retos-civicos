class RemoveCompanyCharterFieldFromMembers < ActiveRecord::Migration[5.0]
  def up
    remove_column :members, :company_charter
  end

  def down
    add_column :members, :company_charter, :string
  end
end
