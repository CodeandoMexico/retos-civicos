class AddLegalFieldsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :company_name, :string
    add_column :members, :company_rfc, :string
    add_column :members, :company_charter, :string
  end
end
