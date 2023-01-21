class RemoveCompanyRfcFromMembers < ActiveRecord::Migration[5.0]
  def up
    remove_column :members, :company_rfc
  end

  def down
    add_column :members, :company_rfc, :string
  end
end
